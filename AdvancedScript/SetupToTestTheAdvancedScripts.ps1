# setup to test the AdvancedScripts
if (test-path $env:TEMP\odmon) {
    Remove-Item $env:TEMP\odmon -Recurse -Force
}
$WorkingDir = $PSScriptRoot
$ParentDir = (Get-Item $WorkingDir).Parent
.\$ParentDir\Commands\