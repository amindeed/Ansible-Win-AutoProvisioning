$installResult = $null
$installSuccess = $false

try {
    # Generate uninstaller file content
    $uninstallerScriptContent = @'
# Define the path to the folder to be deleted
$folderPath = Split-Path -Parent -Path $MyInvocation.MyCommand.Path

# Remove the read-only attribute if it is set
if ((Get-Item $folderPath).Attributes -band [System.IO.FileAttributes]::ReadOnly) {
    Set-ItemProperty -Path $folderPath -Name IsReadOnly -Value $false
}

# Delete the folder and its contents
Remove-Item -Path $folderPath -Force -Recurse

$publicDesktopShortcut = [System.Environment]::ExpandEnvironmentVariables("%PUBLIC%\Desktop\RegShot.lnk")
$commonStartMenuShortcut = [System.Environment]::ExpandEnvironmentVariables("%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\RegShot.lnk")

# Check if shared shortcuts exist and remove them
if (Test-Path -Path $publicDesktopShortcut) {
    Remove-Item -Path $publicDesktopShortcut -Force
}
if (Test-Path -Path $commonStartMenuShortcut) {
    Remove-Item -Path $commonStartMenuShortcut -Force
}
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RegShot" -Recurse -Force
'@

    Add-Content "D:\AppServ\RegShot\uninstall.ps1" $uninstallerScriptContent

    $registryPath = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\RegShot"
    $registryValues = @{
        "DisplayName" = "RegShot"
        "DisplayIcon" = "D:\AppServ\RegShot\Regshot-x64-Unicode.exe,0"  
        "UninstallString" = "D:\AppServ\RegShot\uninstall.ps1"
        "DisplayVersion" = "$((Get-Item 'D:\AppServ\RegShot\Regshot-x64-Unicode.exe').VersionInfo.ProductVersion)"
    }
    New-Item -Path $registryPath -Force
    foreach ($key in $registryValues.Keys) {
        Set-ItemProperty -Path $registryPath -Name $key -Value $registryValues[$key]
    }
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut([System.Environment]::ExpandEnvironmentVariables("%PUBLIC%\Desktop\RegShot.lnk"))
    $Shortcut.TargetPath = 'D:\AppServ\RegShot\Regshot-x64-Unicode.exe'
    $Shortcut.Save()
    $WshShell = New-Object -ComObject WScript.Shell
    $Shortcut = $WshShell.CreateShortcut([System.Environment]::ExpandEnvironmentVariables("%ALLUSERSPROFILE%\Microsoft\Windows\Start Menu\Programs\RegShot.lnk"))
    $Shortcut.TargetPath = 'D:\AppServ\RegShot\Regshot-x64-Unicode.exe'
    $Shortcut.Save()
    $installResult = 0
} catch {
    #$errorMessage = $_.Exception.Message
    #Write-Host "ERROR: $errorMessage"
    $installResult = 1
}
if ($installResult -eq 0) {$installSuccess = $true}


if (-not $installSuccess) {
    Write-Output "RegShot installation failed. Exit Code: $installResult"
    exit 1 }