#!/bin/bash

# Importing function run_as_root
source ../RunAsRoot.bash

# Running as root
run_as_root

# Creating wireguard configuration directory and changing the current directory to it
mkdir -p /etc/wireguard

# Generating server keys
bash ./Generate-ServerKeys.bash

# Generating server configuration
bash ./Generate-ServerConfiguration.bash

# Copying server configuration file
cp ./wg0.conf /etc/wireguard/wg0.conf

# Opening Firewall port
firewall-cmd --permanent --add-service=wireguard
firewall-cmd --reload

# Enabling IP Forwarding
if ! grep -q "net.ipv4.ip_forward=1" "/etc/sysctl.conf"; then
  echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
fi
if ! grep -q "net.ipv6.conf.all.forwarding=1" "/etc/sysctl.conf"; then
  echo "net.ipv6.conf.all.forwarding=1" >> /etc/sysctl.conf
fi

# Starting and enabling wireguard service
systemctl enable wg-quick@wg0.service
systemctl daemon-reload
systemctl start wg-quick@wg0
