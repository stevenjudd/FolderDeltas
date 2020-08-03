$OneDrivePath = Join-Path -Path "$env:TEMP" -ChildPath "odmon"
$SavedFileListPath = Join-Path -Path $OneDrivePath -ChildPath "OneDriveFileList.csv"

Get-ChildItem -Path $OneDrivePath -Recurse | 
Select-Object FullName, Length, LastWriteTime, CreationTime | 
Sort-Object -Property FullName | 
ConvertTo-Csv -NoTypeInformation |
Out-File -FilePath $SavedFileListPath
