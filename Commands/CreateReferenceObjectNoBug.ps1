$FileList = Get-ChildItem -Path "$env:TEMP\odmon" -Recurse | 
Select-Object -Property FullName, Length, LastWriteTime, CreationTime | 
Sort-Object -Property FullName | 
ConvertTo-Csv -NoTypeInformation
Out-File -InputObject $FileList -FilePath "$env:TEMP\odmon\OneDriveFileList.csv"
