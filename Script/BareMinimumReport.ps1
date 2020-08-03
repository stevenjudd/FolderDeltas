# get the content to compare
$RefObj = Get-Content -Path "$env:TEMP\odmon\OneDriveFileList.csv"
$DifObj = Get-ChildItem -Path "$env:TEMP\odmon" -Recurse |
Select-Object -Property FullName, Length, LastWriteTime, CreationTime |
Sort-Object -Property FullName |
ConvertTo-Csv -NoTypeInformation

# compare the content
Compare-Object -ReferenceObject $RefObj -DifferenceObject $DifObj

# update the reference file
$FileList = Get-ChildItem -Path "$env:TEMP\odmon" -Recurse | 
Select-Object -Property FullName, Length, LastWriteTime, CreationTime | 
Sort-Object -Property FullName | 
ConvertTo-Csv -NoTypeInformation
Out-File -InputObject $FileList -FilePath "$env:TEMP\odmon\OneDriveFileList.csv"
