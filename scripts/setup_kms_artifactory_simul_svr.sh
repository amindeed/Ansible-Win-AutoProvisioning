#!/bin/bash

[[ $EUID -ne 0 ]] && { echo "Run as root."; exit 1; }

echo "-- Download and extract vlmcsd binary --"

tmp_dir="/tmp/vlmcsd_$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)"
mkdir -p $tmp_dir && cd $tmp_dir

curl -sL https://github.com/Wind4/vlmcsd/releases/download/svn1113/binaries.tar.gz | tar xz

binary_path="binaries/Linux/intel/glibc/vlmcsd-x64-glibc"
[[ ! -f $binary_path ]] && { echo "Binary not found."; exit 1; }

echo "-- Install the 'vlmcsd' binary --"

install -m 755 $binary_path /usr/local/bin/vlmcsd

echo "-- Create 'vlmcsd' systemd service --"

cat > /etc/systemd/system/vlmcsd.service <<'EOF'
[Unit]
Description=KMS Emulator
After=network.target

[Service]
Type=forking
ExecStart=/usr/local/bin/vlmcsd -l /var/log/vlmcsd.log -L 0.0.0.0:1688

[Install]
WantedBy=multi-user.target
EOF

echo "-- Enable and start 'vlmcsd' systemd service --"

systemctl daemon-reload
systemctl enable vlmcsd --now

echo "-- Firewall rule for 'vlmcsd' --"

if systemctl is-active firewalld >/dev/null 2>&1; then
    firewall-cmd --permanent --add-port=1688/tcp >/dev/null
    firewall-cmd --reload >/dev/null
fi

echo "-- Cleanup --"

cd /
rm -rf $tmp_dir

# netstat -ntplu
echo "vlmcsd installed and running on 0.0.0.0:1688"
systemctl status vlmcsd --no-pager


##### Setup Simulated Artifactory ######

## -- Variables --
repo_user="${1:-repouser}"
repo_pass="${2:-repopassword}"
repo_root="/var/www/artifactory/ansible-win-auto-prov-artifacts"
## ---------------

## -- Install packages --

dnf install -y nginx httpd-tools >/dev/null

## -- Create directory structure --

mkdir -p "$repo_root"

# Prepare directories for Core and Basic bundles installation packages
mkdir -p "$repo_root"/7zip
mkdir -p "$repo_root"/adobe-reader
mkdir -p "$repo_root"/beyond-compare
mkdir -p "$repo_root"/cygwin
mkdir -p "$repo_root"/dbeaver
mkdir -p "$repo_root"/dependency-walker
mkdir -p "$repo_root"/draw-io
mkdir -p "$repo_root"/eclipse_jee_ide
mkdir -p "$repo_root"/eclipse_temurin_openjdk
mkdir -p "$repo_root"/firefox
mkdir -p "$repo_root"/git
mkdir -p "$repo_root"/gitextensions
mkdir -p "$repo_root"/greenshot
mkdir -p "$repo_root"/kdiff3
mkdir -p "$repo_root"/keepass
mkdir -p "$repo_root"/keystore-explorer
mkdir -p "$repo_root"/marktext
mkdir -p "$repo_root"/maven
mkdir -p "$repo_root"/ms-dotnet
mkdir -p "$repo_root"/ms-office-16
mkdir -p "$repo_root"/ms-vc-redist
mkdir -p "$repo_root"/nodejs
mkdir -p "$repo_root"/notepadpp/plugins
mkdir -p "$repo_root"/openssl
mkdir -p "$repo_root"/pandoc
mkdir -p "$repo_root"/python2
mkdir -p "$repo_root"/python312
mkdir -p "$repo_root"/regshot
mkdir -p "$repo_root"/sysinternals
mkdir -p "$repo_root"/treesize
mkdir -p "$repo_root"/umldesigner
mkdir -p "$repo_root"/vscode/extensions


# -------------------------------------

DOWNLOAD_ROOT=$repo_root

download() {
    local url="$1"
    local dest="$2"
    local filename=$(basename "$dest")
    
    [[ -f "$dest" ]] && { echo "  [SKIP] $filename"; return 0; }
    
    echo "  [DOWN] $filename"
    if curl -fSkL --progress-bar -o "$dest" "$url"; then
        echo "  [OK]   $filename"
    else
        echo "  [FAIL] $filename - $url"
        return 1
    fi
}


## ------ Download Installer Files from public internet ------
echo ""
echo "=== Downloading... 7-Zip ==="
download "https://www.7-zip.org/a/7z2301-x64.msi" \
    "$DOWNLOAD_ROOT/7zip/7z2301-x64.msi"
echo ""
echo ">>> Similarly, you can downlaod the remaining installer files "
echo ">>> to their corresponding directories in '$repo_root'"
# ------------------------------------------------------------


chown -R nginx:nginx /var/www/artifactory
chmod -R 755 /var/www/artifactory

## -- Set SELinux --
yum install -y policycoreutils-python-utils
semanage fcontext -a -t httpd_sys_content_t "/var/www/artifactory(/.*)?"
restorecon -Rv /var/www/artifactory

## -- HTTP Basic Auth --

htpasswd -cb /etc/nginx/.htpasswd "$repo_user" "$repo_pass" >/dev/null 2>&1
chmod 640 /etc/nginx/.htpasswd
chown root:nginx /etc/nginx/.htpasswd

## -- Nginx config --

cat > /etc/nginx/conf.d/artifactory.conf <<'EOF'
server {
    listen 80;
    server_name simulated-artifactory.local;

    access_log /var/log/nginx/artifactory_access.log;
    error_log /var/log/nginx/artifactory_error.log;

    location /artifactory/ {
        alias /var/www/artifactory/;
        auth_basic "Artifact Repository";
        auth_basic_user_file /etc/nginx/.htpasswd;
        autoindex on;
        autoindex_exact_size off;
        autoindex_localtime on;
        client_max_body_size 0;
    }

    location /health {
        return 200 'OK';
        add_header Content-Type text/plain;
    }
}
EOF

nginx -t >/dev/null 2>&1 || { echo "Nginx config test failed."; exit 1; }

## -- Start service --

systemctl enable nginx --now >/dev/null 2>&1

## -- Firewall --

if systemctl is-active firewalld >/dev/null 2>&1; then
    firewall-cmd --permanent --add-service=http >/dev/null
    firewall-cmd --reload >/dev/null
fi

## -- Output --

ip_addr=$(hostname -I | awk '{print $1}')

echo "
Artifact repo running.

URL:  http://simulated-artifactory.local/artifactory/ansible-win-auto-prov-artifacts
Auth: $repo_user / $repo_pass
IP:   $ip_addr

Add to Windows hosts file:
  $ip_addr    simulated-artifactory.local

AWAP inventory vars:
  pkgs_repo_base_url: \"http://simulated-artifactory.local/artifactory/ansible-win-auto-prov-artifacts\"
  http_auth_username: \"$repo_user\"
  http_auth_password: \"$repo_pass\"
"

# Install filebrowser
curl -fsSL https://raw.githubusercontent.com/filebrowser/get/master/get.sh | bash

# Create directory structure
mkdir -p /srv/filebrowser
chown nginx:nginx /srv/filebrowser

# Initialize config
runuser -u nginx -- /usr/local/bin/filebrowser config init -d /srv/filebrowser/filebrowser.db
runuser -u nginx -- /usr/local/bin/filebrowser config set -d /srv/filebrowser/filebrowser.db \
  --address 0.0.0.0 \
  --port 8080 \
  --root /var/www/artifactory/ansible-win-auto-prov-artifacts

# Create admin user
echo "Creating admin user..."
runuser -u nginx -- /usr/local/bin/filebrowser -d /srv/filebrowser/filebrowser.db users add admin 'filebrowseradmin' --perm.admin

# SELinux context
restorecon -v /usr/local/bin/filebrowser

# Create systemd service
tee /etc/systemd/system/filebrowser.service > /dev/null <<EOF
[Unit]
Description=File Browser
After=network.target
Wants=nginx.service

[Service]
Type=simple
User=nginx
Group=nginx
ExecStart=/usr/local/bin/filebrowser -d /srv/filebrowser/filebrowser.db
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable filebrowser --no-pager
systemctl start filebrowser --no-pager
systemctl status filebrowser --no-pager

echo ""
echo "================================================"
echo "Filebrowser is now running"
echo "Access at: http://VM-IP-ADDRESS:8080"
echo "Username: admin"
echo "Password: filebrowseradmin"
echo "================================================"
echo ""