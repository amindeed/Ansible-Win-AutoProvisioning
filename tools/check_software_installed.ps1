$appName = "Microsoft Office Standard 2016"

$wmiQuery = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*$appName*" }
$regPath1 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
$regPath2 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
$regCheck1 = Get-ChildItem -Path $regPath1 | Where-Object { $_.GetValue("DisplayName") -like "*$appName*" }
$regCheck2 = Get-ChildItem -Path $regPath2 | Where-Object { $_.GetValue("DisplayName") -like "*$appName*" }
if ($wmiQuery -or $regCheck1 -or $regCheck2) { $status = "Installed" } else { $status = "Not Installed" }

Write-Host "`n`n$appName is $status`n`n"

Write-Host "`$wmiQuery = `n$wmiQuery`n`n"
Write-Host "`$regCheck1 = `n$regCheck1`n`n"
Write-Host "`$regCheck1 = `n$regCheck1`n`n"