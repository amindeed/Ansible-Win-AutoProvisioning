
function IsVar($var) {
    if ($null -eq $var) {return $false}
    if ($var -is [string]) {return -not [string]::IsNullOrEmpty($var)}
    if ($var -is [array] -or $var -is [System.Collections.IEnumerable]) {return $var.Count -ne 0}
    return $true
}

$envVars = @(
    @{
        Name = "PYTHON_HOME"
        Value = "D:\AppServ\Python312"
    },
    @{
        Name = "PYTHON_SCRIPTS"
        Value = "D:\AppServ\Python312\Scripts"
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