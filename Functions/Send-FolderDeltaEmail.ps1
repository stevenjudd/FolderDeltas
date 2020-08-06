function Send-FolderDeltaEmail {
    [CmdletBinding()]
    param(
        [string]$To = "to@email.com",
        [string]$From = "from@email.com",
        [ValidateScript( {
                if (Test-Path -Path $_ -PathType Leaf) {
                    $true
                }
                else {
                    Write-Error "LogFile not found. Please enter a valid path for the LogFile content to email"
                }
            })]
        [string]$LogFile,
        [System.Management.Automation.PSCredential]$Credential
    )

    Write-Verbose "Building the content of the email"
    [array]$Body
    $Body = "Report save location: $LogFile"
    $Body += ""
    $Body += $(Get-Content -Path $LogFile | Out-String)

    $Params = @{
        Body        = $Body
        To          = $To
        From        = $From
        Subject     = "OneDrive Automation Report on $(Get-Date -Format "yyyyMMdd-HHmmss")"
        SmtpServer  = "smtp.live.com"
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
    
}
