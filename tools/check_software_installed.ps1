# Run this script on a Windows machine having the software in question already installed,
# in order to detremine its name, as this should be provided in the playbook file, 
# as a value of 'setup.installations.software_components[0].software_fullname' for instance,
# to better process the setup.

$appName = "Software Name" # e.g.: $appName = "Microsoft Office Standard 2016"

$wmiQuery = Get-WmiObject -Class Win32_Product | Where-Object { $_.Name -like "*$appName*" }
$regPath1 = "HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall"
$regPath2 = "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
$regPath3 = "HKLM:\SOFTWARE"
$regCheck1 = Get-ChildItem -Path $regPath1 | Where-Object { $_.GetValue("DisplayName") -like "*$appName*" }
$regCheck2 = Get-ChildItem -Path $regPath2 | Where-Object { $_.GetValue("DisplayName") -like "*$appName*" }
$regCheck3 = Get-ChildItem -Path $regPath3 | Where-Object { $_.GetValue("DisplayName") -like "*$appName*" }
if ($wmiQuery -or $regCheck1 -or $regCheck2 -or $regCheck3) { $status = "Installed" } else { $status = "Not Installed" }

Write-Host "`n`n$appName is $status`n`n"

Write-Host "`$wmiQuery = `n$wmiQuery`n`n"
Write-Host "`$regCheck1 = `n$regCheck1`n`n"
Write-Host "`$regCheck2 = `n$regCheck2`n`n"
Write-Host "`$regCheck3 = `n$regCheck3`n`n"