# this is a controller script to run the Folder Delta check on $env:TEMP\odmod
# and output the results to a log file and the console
$Path = Join-Path -Path $env:TEMP -ChildPath "odmon"
$ReferenceFilePath = Join-Path -Path $Path -ChildPath "FolderFileList.csv"
$LogFileBaseName = "odlog"
$LogFileType = "csv"
$To = "to@email.com"
$From = "from@email.com"
$LogFile = Join-Path -Path $Path -ChildPath "$LogFileBaseName.$LogFileType"

if (Test-Path -Path $ReferenceFilePath) {
    try {
        $InvokeFolderDeltaCheckParams = @{
            "Path"              = $Path
            "ReferenceFilePath" = $ReferenceFilePath
            "LogFileBaseName"   = $LogFileBaseName
            "LogFileType"       = $LogFileType
            "Verbose"           = $true
        }
        Invoke-FolderDeltaCheck @InvokeFolderDeltaCheckParams
    
        # email the results
        # $SendFolderDeltaEmailParams = @{
        #     "To"         = $To
        #     "From"       = $From
        #     "LogFile"    = $LogFile
        #     "Credential" = (Get-Credential -Credential "from@email.com")
        # }
        # Send-FolderDeltaEmail @SendFolderDeltaEmailParams
        $SendFolderDeltaEmailParams = @{
            "To"         = $To
            "From"       = $From
            "LogFile"    = $LogFile
            "Credential" = (Get-Credential -Credential "stevenkjudd@hotmail.com")
        }
        Send-FolderDeltaEmail @SendFolderDeltaEmailParams
    } #end try
    catch {
        throw $_
    }
}
else {
    # create the reference file
    Update-FolderReferenceFile -Path $Path -ReferenceFilePath $ReferenceFilePath
}
