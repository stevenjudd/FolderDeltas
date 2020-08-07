function Invoke-FdFolderDeltaCheck {
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
        [string]$ReferenceFilePath = ".\ReferenceList.csv",
        [string]$LogFileBaseName = "FolderDeltaCheck-$(Get-Date -Format "yyyyMMdd-HHmmss")",
        [ValidateSet("csv", "json", "txt")]
        [string]$LogFileType = "csv"
    )

    Write-Verbose "create the log file"
    $LogPath = Join-Path -Path $Path -ChildPath "$LogFileBaseName.$LogFileType"
    
    try {
        if (-not(Test-Path $LogPath)) {
            $null = New-Item -Path $LogPath -ItemType "File" -Force -ErrorAction Stop
        }
    }
    catch {
        throw "Unable to create logfile: $LogPath"
    }

    Write-Verbose "get the changes to Path folder files and log the results"
    try {
        Write-Verbose "run the script to generate the deltas"
        $FolderDeltas = Get-FolderDelta -Path $Path -ReferenceFilePath $ReferenceFilePath
        if ($FolderDeltas) {
            switch ($LogFileType) {
                "csv" { $LogContent = $FolderDeltas | ConvertTo-Csv -NoTypeInformation -ErrorAction Stop }
                "json" { $LogContent = $FolderDeltas | ConvertTo-Json -ErrorAction Stop }
                "txt" { $LogContent = $FolderDeltas | Out-String -ErrorAction Stop }
            } # end switch $LogFileType
            $LogContent | Out-File -FilePath $LogPath -Force -ErrorAction Stop
            $FolderDeltas
        }
        else {
            Write-Warning "No deltas found for folder: $Path"
        }
    }
    catch {
        throw $_
    }

    Write-Verbose "update the deltas"
    try {
        Update-FolderReferenceFile -Path $Path -ReferenceFilePath $ReferenceFilePath
    }
    catch {
        throw $_
    }
} # end function Invoke-FdFolderDeltaCheck
