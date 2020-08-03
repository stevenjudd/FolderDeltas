# get the changes to OneDrive files and log the results
$LogPath = Join-Path -Path "$env:TEMP" -ChildPath "odlogs"
if (-not(Test-Path $LogPath)) {
    New-Item -Path $LogPath -ItemType Directory -Force
}
$LogFile = Join-Path -Path $LogPath -ChildPath "OneDriveModifyNewRemoveLog-$(Get-Date -Format 'yyyyMMdd-HHmmss').txt"
$XmlFile = Join-Path -Path $LogPath -ChildPath "OneDriveModifyNewRemoveXml-$(Get-Date -Format 'yyyyMMdd-HHmmss').xml"
try {
    # run the script to generate the deltas
    $OneDriveDeltas = & (Join-Path -Path $PSScriptRoot -ChildPath "OneDriveDeltasOutput.ps1")
    if ($OneDriveDeltas) {
        $OneDriveDeltas | Export-Clixml -Path $XmlFile -Force -ErrorAction Stop
        $OneDriveDeltas | ConvertTo-Csv -NoTypeInformation -ErrorAction Stop | Out-File -FilePath $LogFile -Force -ErrorAction Stop
    }
}
catch {
    throw $_
}

# email the results
$To = 'to@email.com'
$From = 'from@email.com'

#putting the here string here so it doesn't "ugly up" the code below
$Body = @"
Report save location: $LogFile
Object save location: $XmlFile

$(Get-Content -Path $LogFile | Out-String)
"@

if (Test-Path -Path $env:TEMP\odlogs\emailCreds.xml) {
    if ($OneDriveDeltas) {
        $Credential = Import-Clixml -Path "$env:TEMP\odlogs\emailCreds.xml"
        $Params = @{
            Body        = $Body
            To          = $To
            From        = $From
            Subject     = "OneDrive Automation Report on $(Get-Date -Format 'yyyyMMdd-HHmmss')"
            SmtpServer  = 'smtp.live.com'
            Port        = "587"
            Credential  = $Credential
            UseSsl      = $true
            ErrorAction = "Stop"
        }
        try {
            Send-MailMessage @Params
        }
        catch {
            throw $_
        }
    } #end if ($OneDriveDeltas)
    
}
else {
    Write-Warning "Unable to locate credential file for email account"
}

# update the deltas
try {
    Invoke-Expression -Command (Get-Content -Path (Join-Path -Path $PSScriptRoot -ChildPath "OneDriveDeltasUpdate.ps1") | Out-String)
}
catch {
    throw $_
}
