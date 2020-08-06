function Update-FolderReferenceFile {
    [CmdletBinding()]
    param(
        [ValidateScript( {
                if (Test-Path -Path $_ -PathType Container) {
                    $true
                }
                else {
                    Write-Error "Folder not found. Please enter a valid folder path to update the reference file."
                }
            })]
        [string]$Path = ".",
        [string]$ReferenceFilePath = "ReferenceList.csv"
    )

    try {
        Get-ChildItem -Path $Path -Recurse | 
        Select-Object FullName, Length, LastWriteTime, CreationTime | 
        Sort-Object -Property FullName | 
        ConvertTo-Csv -NoTypeInformation |
        Out-File -FilePath $ReferenceFilePath
    }
    catch {
        throw $_
    }
}
