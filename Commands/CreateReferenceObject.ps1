Get-ChildItem -Path "$env:TEMP\odmon" -Recurse -Exclude "OneDriveFileList.csv" | 
Select-Object FullName, Length, LastWriteTime, CreationTime | 
Sort-Object -Property FullName | 
ConvertTo-Csv -NoTypeInformation |
Out-File -FilePath "$env:TEMP\odmon\OneDriveFileList.csv"