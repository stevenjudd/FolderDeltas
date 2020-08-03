# setup to test the AdvancedScripts
if (test-path $env:TEMP\odmon) {
    Remove-Item $env:TEMP\odmon -Recurse -Force
}
& $PSScriptRoot\CreateTestFoldersAndFiles.ps1
& $PSScriptRoot\CreateReferenceObject.ps1
$TestScripts = Get-ChildItem -Path $PSScriptRoot -Filter Test?--*
foreach ($item in $TestScripts) {
    & $item.FullName
}
