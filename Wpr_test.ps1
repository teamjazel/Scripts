Function Invoke-WPRTrace {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,Position=0)]
        [string]$Name,
        [Parameter(Mandatory=$true,Position=1)]
        [ValidateRange(1, 600)]
        [int]$Seconds,
        [Parameter(Mandatory=$false)]
        [Switch]$Open,
        [Parameter(Mandatory=$false)]
        [Switch]$CreateZip
    )

    # Define ETL file path as variable
    $ETL_Path = "C:\WPR_Test\$Name.etl"

    # Define zip file path as variable
    $ETL_Zip = "C:\WPR_Test\$Name.zip"


    # Start WPR light filemode trace
    WPR -start generalprofile.light -filemode

    Write-Output ""
    Write-Output "$Seconds second WPR started"; Start-Sleep -Seconds $Seconds
    Write-Output ""

    # Stop WPR trace and save to path defined in $ETL_Path
    WPR -stop $ETL_Path; Start-Sleep -Seconds 5
    Write-Output "WPR file $Name created"
    Write-Output "Full path $ETL_Path"; Start-Sleep -Seconds 5

    # Opens etl file if parameter is present
    If ($Open.IsPresent) {
        Write-Output "Opening $ETL_Path in Windows Performance Analyzer"
        Write-Output ""
        Invoke-Item $ETL_Path
    }

    # Compress etl file if parameter is present
    If ($CreateZip.IsPresent) {
        Write-Output "Compressing $ETL_Path"
        Write-Output ""
        Compress-Archive -Path $ETL_Path -DestinationPath $ETL_Zip -Update
        Write-Output "Zip file $ETL_Zip created"
    }

    # Remove every file except zip extensions
    Remove-Item -Path C:\WPR_Test\* -Exclude *.zip,*.etl -Recurse -Force

}