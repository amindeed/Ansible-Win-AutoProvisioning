# Define the regular string you want to convert
$regularString = "%USERPROFILE%\AppData\Local\Microsoft\WindowsApps;%NODEJS_HOME%;"

# Convert the regular string to bytes
$bytes = [System.Text.Encoding]::Unicode.GetBytes($regularString)
$hexString = "hex(2):" + ($bytes | ForEach-Object { '{0:X2}' -f $_ })
$hexString = $hexString.Replace(" ",",")

# Display the hexadecimal string
Write-Host $hexString