$kmsserver = $args[0]

$DelKMSHost = (Start-Process -FilePath "C:\Windows\SysWOW64\Cscript.exe" -ArgumentList "'C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs' /remhst" -Wait -PassThru).ExitCode
#if ($DelKMSHost -ne 0) { throw "Failed to remove old KMS Server settings." }

$SetKMSHost = (Start-Process -FilePath "C:\Windows\SysWOW64\Cscript.exe" -ArgumentList "`"C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs`" /sethst:$kmsserver" -Wait -PassThru).ExitCode
if ($SetKMSHost -ne 0) { throw "Failed to set KMS Server." }

$ActivateMSOffice = (Start-Process -FilePath "C:\Windows\SysWOW64\Cscript.exe" -ArgumentList "`"C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs`" /act" -Wait -PassThru).ExitCode
if ($ActivateMSOffice -ne 0) { throw "Failed to activate Office 2016." }

# ----------------------------------------------

$checkOfficeActivation = (Start-Process -FilePath "C:\Windows\SysWOW64\Cscript.exe" -ArgumentList "`"C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs`" /dstatus" -Wait -PassThru).ExitCode

echo "`n`n`n$checkOfficeActivation`n`n`n"



# --------------------------------------------


# Define the output as a multiline string
$output = @"
Microsoft (R) Windows Script Host Version 5.812
Copyright (C) Microsoft Corporation. All rights reserved.

---Processing--------------------------
---------------------------------------
PRODUCT ID: 00340-80000-00000-AA287
SKU ID: dedfa23d-6ed1-45a6-85dc-63cae0546de6
LICENSE NAME: Office 16, Office16StandardVL_KMS_Client edition
LICENSE DESCRIPTION: Office 16, VOLUME_KMSCLIENT channel
LICENSE STATUS:  ---OOB_GRACE---
ERROR CODE: 0x4004F00C
ERROR DESCRIPTION: The Software Licensing Service reported that the application is running within the valid grace period.
REMAINING GRACE: 29 days  (43194 minute(s) before expiring)
Last 5 characters of installed product key: DRTFM
Activation Type Configuration: ALL
	DNS auto-discovery: KMS name not available
	Activation Interval: 120 minutes
	Renewal Interval: 10080 minutes
	KMS host caching: Enabled
---------------------------------------
---------------------------------------
---Exiting-----------------------------
"@

# Split the output into lines and find the line beginning with "LICENSE STATUS:"
$lines = $output -split "`n"
$licenseStatusLine = $lines | Where-Object { $_ -match "^LICENSE STATUS:" }

# Check the value of the license status
if ($licenseStatusLine -match "---LICENSED---") {
    Write-Host "Licensed"
} elseif ($licenseStatusLine -match "---OOB_GRACE---") {
    Write-Host "Out of Box Grace Period"
} else {
    Write-Host "Unknown status"
}


# ---------------------------------------------------



# Define the command to execute
$command = 'C:\Windows\SysWOW64\Cscript.exe "C:\Program Files (x86)\Microsoft Office\Office16\ospp.vbs" /dstatus'

try {
    # Run the command and capture its output
    $output = Invoke-Expression -Command $command

    # Split the output into lines
    $lines = $output -split [Environment]::NewLine

    # Find the line beginning with "LICENSE STATUS:"
    $licenseStatusLine = $lines | Where-Object { $_ -match "^LICENSE STATUS:" }

    # Check the value of the license status
    if ($licenseStatusLine -match "---LICENSED---") {
        Write-Host "Licensed"
    } elseif ($licenseStatusLine -match "---OOB_GRACE---") {
        Write-Host "Out of Box Grace Period"
    } else {
        Write-Host "Unknown status"
    }
} catch {
    Write-Host "Error: $_"
}
