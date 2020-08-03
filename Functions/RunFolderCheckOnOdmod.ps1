# this is a controller script to run the Folder Delta check on $env:TEMP\odmod
# and output the results to a log file and the console
Invoke-FolderDeltaCheck -Path $env:TEMP\odmod -LogFile $env:TEMP\odlog -LogFileType CSV