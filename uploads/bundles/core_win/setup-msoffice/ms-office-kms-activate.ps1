# On artifacts server (e.g. generic Artifactory repository), this file should be placed
# under the same directory as 'Microsoft Office 2016 x64' installer bundle file;
# (`ms-office-16/scripts/ms-office-kms-activate.ps1`)
# kms.server.local

#$msOfficeInstallPath = "C:\Program Files (x86)\Microsoft Office\Office16"
$msOfficeInstallPath = "C:\Program Files\Microsoft Office\Office16"
$kmsserver = $args[0]

try {
    # Check if Office is already activated
    $checkOfficeActivation = 'C:\Windows\SysWOW64\Cscript.exe "$msOfficeInstallPath\ospp.vbs" /dstatus'
    $checkOutput = Invoke-Expression -Command $checkOfficeActivation
    $lines = $checkOutput -split [Environment]::NewLine
    $licenseStatusLine = $lines | Where-Object { $_ -match "^LICENSE STATUS:" }
    $kmsOverrideLine = $lines | Where-Object { $_ -match "^\s*KMS machine registry override defined:" }

    if (($licenseStatusLine -match "---LICENSED---") -and ($kmsOverrideLine -match $kmsserver)) {
        Write-Host "OK_NO_CHANGE"
    } else {

        $DelKMSHost = (Start-Process -FilePath "C:\Windows\SysWOW64\Cscript.exe" -ArgumentList "'$msOfficeInstallPath\ospp.vbs' /remhst" -Wait -PassThru).ExitCode
        #if ($DelKMSHost -ne 0) { 
        #    Write-Host "[KO_FAILURE] Failed to remove old KMS Server settings."
        #    exit 0
        #}

        $SetKMSHost = (Start-Process -FilePath "C:\Windows\SysWOW64\Cscript.exe" -ArgumentList "`"$msOfficeInstallPath\ospp.vbs`" /sethst:$kmsserver" -Wait -PassThru).ExitCode
        if ($SetKMSHost -ne 0) { 
            Write-Host "[KO_FAILURE] Failed to set KMS Server."
            exit 0
        }

        $ActivateMSOffice = (Start-Process -FilePath "C:\Windows\SysWOW64\Cscript.exe" -ArgumentList "`"$msOfficeInstallPath\ospp.vbs`" /act" -Wait -PassThru).ExitCode
        if ($ActivateMSOffice -ne 0) { 
            Write-Host "[KO_FAILURE] Failed to activate Office 2016."
            exit 0
        }

        $checkOutput = Invoke-Expression -Command $checkOfficeActivation
        $lines = $checkOutput -split [Environment]::NewLine
        $licenseStatusLine = $lines | Where-Object { $_ -match "^LICENSE STATUS:" }
        $kmsOverrideLine = $lines | Where-Object { $_ -match "^\s*KMS machine registry override defined:" }

        if (($licenseStatusLine -match "---LICENSED---") -and ($kmsOverrideLine -match $kmsserver)) {
            Write-Host "OK_CHANGE"
        } else {
            Write-Host "[KO_FAILURE] MS Office not activated: `"$licenseStatusLine`""
        }
    }
} catch {
    $errorMessage = $_.Exception.Message
    Write-Host "Unexpected exception/error: $errorMessage"
    exit 1
}

