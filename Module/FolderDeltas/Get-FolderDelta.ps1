function Get-FolderDelta {
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
        [ValidateScript( {
                if (Test-Path -Path $_ -PathType Leaf) {
                    $true
                }
                else {
                    Write-Error "Reference file not found. Please enter a valid path for the reference file to compare against the specified Path."
                }
            })]
        [string]$ReferenceFilePath = ".\ReferenceList.csv"
    )

    Write-Verbose "build file list to check for changes in Path folder"
    $FolderContentsPast = Get-Content -Path $ReferenceFilePath

    $FolderContentsNow = Get-ChildItem -Path $Path -Recurse |
    Select-Object FullName, Length, LastWriteTime, CreationTime |
    Sort-Object -Property FullName |
    ConvertTo-Csv -NoTypeInformation

    Write-Verbose "compare the two file lists for differences"
    $Deltas = Compare-Object -ReferenceObject $FolderContentsNow -DifferenceObject $FolderContentsPast

    if ($Deltas) {
        Write-Verbose "check deltas and add SideIndicator property"
        $DeltaList = foreach ($item in $Deltas) {
            switch ($item.SideIndicator) {
                "=>" { $SideInidcator = "PreviousList" }
                "<=" { $SideInidcator = "FolderContentsNow" }
            }
            $InputObject = $item.InputObject | ConvertFrom-Csv -Header "FullName", "Length", "LastWriteTime", "CreationTime"
            [PSCustomObject]@{
                FullName      = $InputObject.FullName
                Length        = $InputObject.Length
                LastWriteTme  = $InputObject.LastWriteTime
                CreationTime  = $InputObject.CreationTime
                SideIndicator = $SideInidcator
            }
        } # end foreach ($item in $Deltas)
        
        $DeltaListGroup = $DeltaList | Group-Object -Property FullName
        
        Write-Verbose "add Status property to each record"
        foreach ($AddModifyRemove in $DeltaListGroup) {
            if ($AddModifyRemove.Count -gt 1) {
                $AddModifyRemove.Group | Add-Member -NotePropertyName Status -NotePropertyValue "Modified" -PassThru
            }
            elseif ($AddModifyRemove.Group.SideIndicator -eq "FolderContentsNow") {
                $AddModifyRemove.Group | Add-Member -NotePropertyName Status -NotePropertyValue "Added" -PassThru
            }
            elseif ($AddModifyRemove.Group.SideIndicator -eq "PreviousList") {
                $AddModifyRemove.Group | Add-Member -NotePropertyName Status -NotePropertyValue "Removed" -PassThru
            }
            else {
                Write-Error "There is a type error for the data: $AddModifyRemove"
            }
        } # end foreach ($AddModifyRemove in $DeltaListGroup)
    }
} # end function Get-FolderDelta
