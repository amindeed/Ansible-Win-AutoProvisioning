
function IsVar($var) {
    if ($null -eq $var) {return $false}
    if ($var -is [string]) {return -not [string]::IsNullOrEmpty($var)}
    if ($var -is [array] -or $var -is [System.Collections.IEnumerable]) {return $var.Count -ne 0}
    return $true
}

$envVars = @(
    @{
        Name = "NODEJS_HOME"
        Value = "D:\AppServ\nodejs\node-v18.18.0-win-x64"
    },
    @{
        Name = "JAVA_HOME"
        Value = "C:\java"
    }
)

foreach ($envVar in $envVars) {

    $currentEnvVarValue = [Environment]::GetEnvironmentVariable($($envVar.Name), [System.EnvironmentVariableTarget]::User)

    if (IsVar $currentEnvVarValue) {
        Add-NewEnvValueToPath $($envVar.Name)
    } else {
        Add-NewEnvValueToPath $($envVar.Name) $($envVar.Value)
    }
}