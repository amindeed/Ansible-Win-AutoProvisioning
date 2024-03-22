# Variables
$kmsArtifactoryipAddress = "192.168.56.11"      # Replace with your VM's IP
# ---------------------

# Make Windows Server host pingable
Enable-NetFirewallRule -Name FPS-ICMP4-ERQ-In

# Enable/Init. WinRM service
$svc = Get-Service WinRM -ErrorAction Stop
if ($svc.Status -ne 'Running') {
    winrm quickconfig -quiet
}

# Create HTTP listener (if it doesn't exist)
$httpListener = winrm enumerate winrm/config/listener 2>$null |
    Where-Object { $_ -match 'Transport = HTTP' }
if (-not $httpListener) {
    winrm create winrm/config/Listener?Address=*+Transport=HTTP
	Write-Host "HTTP listener created"
}

# Enable PS-Remoting
Enable-PSRemoting -Force -SkipNetworkProfileCheck

# Firewall (HTTP / 5985)
if (-not (Get-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule `
        -Name "WinRM-HTTP-In" `
        -DisplayName "Windows Remote Management (HTTP-In)" `
        -Protocol TCP `
        -LocalPort 5985 `
        -Direction Inbound `
        -Action Allow
}

# Get the hostname/FQDN
$hostname = $env:COMPUTERNAME
$fqdn = [System.Net.Dns]::GetHostByName($hostname).HostName

# Check HTTPS listener
$httpsListener = winrm enumerate winrm/config/listener 2>$null |
    Where-Object { $_ -match 'Transport = HTTPS' }

# Create self-signed cert and create HTTPS listener (if it doesn't exist)
if (-not $httpsListener) {
    # Create self-signed certificate valid for 10 years
    $cert = New-SelfSignedCertificate `
        -DnsName $fqdn, $hostname, "localhost" `
        -CertStoreLocation "Cert:\LocalMachine\My" `
        -NotAfter (Get-Date).AddYears(10) `
        -KeyExportPolicy NonExportable `
        -KeySpec KeyExchange `
        -Provider "Microsoft RSA SChannel Cryptographic Provider"
    
    Write-Host "Created certificate with thumbprint: $($cert.Thumbprint)"
    
    # Create the HTTPS listener
    $thumbprint = $cert.Thumbprint
    winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$fqdn`";CertificateThumbprint=`"$thumbprint`"}"
    
    Write-Host "HTTPS listener created"
}

# Firewall (HTTPS / 5986)
if (-not (Get-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -ErrorAction SilentlyContinue)) {
    New-NetFirewallRule `
        -Name "WinRM-HTTPS-In" `
        -DisplayName "Windows Remote Management (HTTPS-In)" `
        -Protocol TCP `
        -LocalPort 5986 `
        -Direction Inbound `
        -Action Allow
}

# Allow non-domain / workgroup clients
Set-Item WSMan:\localhost\Client\TrustedHosts -Value "*" -Force

# Allow local users to authenticate remotely
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" `
    /v LocalAccountTokenFilterPolicy `
    /t REG_DWORD /d 1 /f | Out-Null

# Restart WinRM to ensure clean state
Restart-Service WinRM


# Add KMS and Artifactory hostnames to 'hosts'
$hostsPath = "$env:SystemRoot\System32\drivers\etc\hosts"
$entries = @(
    @{ IP = $kmsArtifactoryipAddress; Hostname = "simulated-artifactory.local" }
    @{ IP = $kmsArtifactoryipAddress; Hostname = "kms.server.local" }
)

$content = Get-Content $hostsPath -Raw

foreach ($entry in $entries) {
    $pattern = "^\s*[\d\.]+\s+$($entry.Hostname)\s*$"
    if ($content -notmatch "(?m)$pattern") {
        Add-Content -Path $hostsPath -Value "$($entry.IP)`t$($entry.Hostname)"
    } 
}