# Global startup script, executes all scripts in:
# "C:\opt\ScriptPS\Starter\startup_scripts\".
# To be stored as "C:\opt\ScriptPS\Starter\starter.ps1"

# Prevent execution when run by an Admin user:
if (
    ([Security.Principal.WindowsPrincipal]
     [Security.Principal.WindowsIdentity]::GetCurrent()
    ).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
) {
    Write-Error "This script must NOT be run with Administrator privileges."
    exit 1
}

$scriptDirectory = "C:\opt\ScriptPS\Starter\startup_scripts"

$scriptFiles = Get-ChildItem -Path $scriptDirectory -Filter *.ps1 | Sort-Object

foreach ($scriptFile in $scriptFiles) {
    Write-Host "Executing script: $($scriptFile.Name)"
    & $scriptFile.FullName
}