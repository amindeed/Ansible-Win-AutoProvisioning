# Simulatin of Global startup script
# To be stored as "C:\opt\ScriptPS\Starter\starter.ps1"

$scriptDirectory = "C:\opt\ScriptPS\Starter\startup_scripts"

$scriptFiles = Get-ChildItem -Path $scriptDirectory -Filter *.ps1 | Sort-Object

foreach ($scriptFile in $scriptFiles) {
    Write-Host "Executing script: $($scriptFile.Name)"
    & $scriptFile.FullName
}