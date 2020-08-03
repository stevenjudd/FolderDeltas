#script to check for changes in OneDrive
$OneDrivePath = Join-Path -Path "$env:TEMP" -ChildPath "odmon"
$SavedFileListPath = Join-Path -Path $OneDrivePath -ChildPath "OneDriveFileList.csv"
$OneDrivePast = Get-Content -Path $SavedFileListPath
$OneDriveCurrent = Get-ChildItem -Path $OneDrivePath -Recurse |
Select-Object FullName, Length, LastWriteTime, CreationTime |
Sort-Object -Property FullName |
ConvertTo-Csv -NoTypeInformation

# compare the two file lists for differences
$Deltas = Compare-Object -ReferenceObject $OneDriveCurrent -DifferenceObject $OneDrivePast

if ($Deltas) {
    $DeltaList = foreach ($item in $Deltas) {
        switch ($item.SideIndicator) {
            "=>" { $SideInidcator = "PreviousList" }
            "<=" { $SideInidcator = "OneDriveCurrent" }
        }
        $InputObject = $item.InputObject | ConvertFrom-Csv -Header "FullName", "Length", "LastWriteTime", "CreationTime"
        [PSCustomObject]@{
            FullName      = $InputObject.FullName
            Length        = $InputObject.Length
            LastWriteTme  = $InputObject.LastWriteTime
            CreationTime  = $InputObject.CreationTime
            SideIndicator = $SideInidcator
        }
    } #end foreach ($item in $Deltas)
    
    $DeltaListGroup = $DeltaList | Group-Object -Property FullName
    
    foreach ($AddModifyRemove in $DeltaListGroup) {
        #consider replacing with switch
        if ($AddModifyRemove.Count -gt 1) {
            $AddModifyRemove.Group | Add-Member -NotePropertyName Status -NotePropertyValue "Modified" -PassThru
        }
        elseif ($AddModifyRemove.Group.SideIndicator -eq "OneDriveCurrent") {
            $AddModifyRemove.Group | Add-Member -NotePropertyName Status -NotePropertyValue "Added" -PassThru
        }
        elseif ($AddModifyRemove.Group.SideIndicator -eq "PreviousList") {
            $AddModifyRemove.Group | Add-Member -NotePropertyName Status -NotePropertyValue "Removed" -PassThru
        }
        else {
            Write-Error "There is a type error for the data: $AddModifyRemove"
        }
    } #end foreach ($AddModifyRemove in $DeltaListGroup)
}
