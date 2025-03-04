#!/bin/bash
# installation.sh
# This script installs and configures the necessary services and tools for the Node.js backend with Apache as a reverse proxy.

# ----------------------------
# Update and Upgrade System
# ----------------------------
sudo apt-get update
sudo apt-get upgrade -y

# ----------------------------
# Install Apache Web Server
# ----------------------------
sudo apt-get install -y apache2

# ----------------------------
# Install MySQL Database Server
# ----------------------------
sudo apt-get install -y mysql-server

# Secure MySQL Installation Automatically
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'ThisIsNotSecurePLeaseFix';" # TODO Replace plain text password
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "FLUSH PRIVILEGES;"
# Maybe remove comment in prod
# sudo mysql -e "DROP DATABASE IF EXISTS test;"

# ----------------------------
# Install Node.js and PM2
# ----------------------------
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo npm install -g pm2

# ----------------------------
# Configure Apache as a Reverse Proxy for Node.js
# ----------------------------
sudo a2enmod proxy
sudo a2enmod proxy_http

sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.bak

sudo bash -c 'cat > /etc/apache2/sites-available/000-default.conf << EOF
<VirtualHost *:80>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    ProxyRequests Off
    ProxyPass / http://localhost:3000/
    ProxyPassReverse / http://localhost:3000/

    <Directory "/var/www/html">
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF'

sudo systemctl restart apache2

# ----------------------------
# Install Security Tools: Snort and IPTables
# ----------------------------
sudo apt-get install -y snort iptables-persistent

# Enable Snort Service
sudo systemctl enable snort
sudo systemctl restart snort

# Log completion
echo "Installation completed successfully. Node.js, Apache reverse proxy, and security tools are configured."