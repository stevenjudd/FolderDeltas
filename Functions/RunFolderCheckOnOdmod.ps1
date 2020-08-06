# this is a controller script to run the Folder Delta check on $env:TEMP\odmod
# and output the results to a log file and the console
try {
    $InvokeFolderDeltaCheckParams = @{
        "Path"              = (Join-Path -Path $env:TEMP -ChildPath "odmon")
        "ReferenceFilePath" = Join-Path (Join-Path -Path $env:TEMP -ChildPath "odmon") OneDriveFileList.csv
        "LogFileBaseName"   = "odlog"
        "LogFileType"       = "csv"
        "Verbose"           = $true
    }
    Invoke-FolderDeltaCheck @InvokeFolderDeltaCheckParams

    # email the results
    # $SendFolderDeltaEmailParams = @{
    #     "To"         = "to@email.com"
    #     "From"       = "from@email.com"
    #     "LogFile"    = "$env:TEMP\odlog.csv"
    #     "Credential" = (Get-Credential -Credential "from@email.com")
    # }
    # Send-FolderDeltaEmail @SendFolderDeltaEmailParams
    $SendFolderDeltaEmailParams = @{
        "To"         = "stevenjudd@outlook.com"
        "From"       = "stevenkjudd@hotmail.com"
        "LogFile"    = Join-Path (Join-Path -Path $env:TEMP -ChildPath "odmon") "odlog.csv"
        "Credential" = (Get-Credential -Credential "stevenkjudd@hotmail.com")
    }
    Send-FolderDeltaEmail @SendFolderDeltaEmailParams
}
catch {
    throw $_
}