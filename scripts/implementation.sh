#!/bin/bash
# implementation.sh
# This script implements security policies using IPTables firewall rules, configures the Snort IDS, and secures MySQL.

# ----------------------------
# Secure MySQL Automatically
# ----------------------------
sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'ThisIsNotSecurePLeaseFix';" # TODO Replace plain text password
sudo mysql -e "DELETE FROM mysql.user WHERE User='';"
sudo mysql -e "FLUSH PRIVILEGES;"
# Maybe remove comment in prod
# sudo mysql -e "DROP DATABASE IF EXISTS test;" 

# ----------------------------
# IPTables Firewall Configuration
# ----------------------------

# Flush all current IPTables rules
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X

# Set default policies: drop all incoming and forwarded traffic; allow all outgoing traffic
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# Allow all traffic on the loopback interface
sudo iptables -A INPUT -i lo -j ACCEPT

# Allow incoming packets that are part of established or related connections
sudo iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow incoming SSH traffic on port 22
sudo iptables -A INPUT -p tcp --dport 22 -m state --state NEW -j ACCEPT

# Allow incoming HTTP traffic on port 80
sudo iptables -A INPUT -p tcp --dport 80 -m state --state NEW -j ACCEPT

# Allow incoming HTTPS traffic on port 443
sudo iptables -A INPUT -p tcp --dport 443 -m state --state NEW -j ACCEPT

# Allow incoming Node.js backend traffic on port 3000
sudo iptables -A INPUT -p tcp --dport 3000 -m state --state NEW -j ACCEPT

# Log dropped packets
sudo iptables -A INPUT -j LOG --log-prefix "IPTables-Dropped: " --log-level 4

# Save IPTables rules persistently
sudo netfilter-persistent save

# ----------------------------
# Snort IDS Configuration
# ----------------------------

# Backup original Snort configuration file
sudo cp /etc/snort/snort.conf /etc/snort/snort.conf.bak

# Add custom Snort rule for detecting ICMP traffic
echo 'alert icmp any any -> any any (msg:"ICMP Packet Detected"; sid:1000001; rev:1;)' | sudo tee -a /etc/snort/rules/local.rules

# Restart Snort to load new rules
sudo systemctl restart snort

# Log completion message
echo "IPTables firewall policies, MySQL security settings, and Snort IDS configuration have been successfully implemented."