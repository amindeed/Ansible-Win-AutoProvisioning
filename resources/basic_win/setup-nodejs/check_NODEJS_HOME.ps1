
function IsVar($var) {
    if ($null -eq $var) {return $false}
    if ($var -is [string]) {return -not [string]::IsNullOrEmpty($var)}
    if ($var -is [array] -or $var -is [System.Collections.IEnumerable]) {return $var.Count -ne 0}
    return $true
}

$envVar = @{
        Name = "NODEJS_HOME"
        Value = "D:\AppServ\nodejs\NodeJS v18.18.0\node-v18.18.0-win-x64"
}

$currentEnvVarValue = [Environment]::GetEnvironmentVariable($($envVar.Name), [System.EnvironmentVariableTarget]::User)

if (IsVar $currentEnvVarValue) {
    Add-NewEnvValueToPath $($envVar.Name)
} else {
    Add-NewEnvValueToPath $($envVar.Name) $($envVar.Value)
}
