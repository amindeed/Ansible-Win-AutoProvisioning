
function IsVar($var) {
    if ($null -eq $var) {return $false}
    if ($var -is [string]) {return -not [string]::IsNullOrEmpty($var)}
    if ($var -is [array] -or $var -is [System.Collections.IEnumerable]) {return $var.Count -ne 0}
    return $true
}

$envVar = @{
        Name = "JAVA_HOME"
        Value = "D:\AppServ\Java\Eclipse Temurin JDK with Hotspot 11.0.20.1+1 (x64)"
}

$currentEnvVarValue = [Environment]::GetEnvironmentVariable($($envVar.Name), [System.EnvironmentVariableTarget]::User)

if (IsVar $currentEnvVarValue) {
    Add-NewEnvValueToPath "%$($envVar.Name)%\bin" -nopercents
} else {
    Set-EnvironmentVariable -envVarName $envVar.Name -envVarValue $envVar.Value
    Add-NewEnvValueToPath "%$($envVar.Name)%\bin" -nopercents
}