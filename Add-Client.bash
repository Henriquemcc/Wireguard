#!/bin/bash

# Adds a client public key, pre-shared key and IP Addresses to the server

# Importing function run_as_root
source ../RunAsRoot.bash

# Running as root
run_as_root

# Getting device name
echo -n "Type the device name: "
read -r name

# Getting IPv4 last octet
echo -n "Type the client IPv4 last octet (only decimal numbers, eg. 2): "
read -r ipv4_last_octet

# Getting IPv6 last hextet
echo -n "Type the client IPv6 last hextet (only hexadecimal numbers, eg. 2): "
read -r ipv6_last_hextet

# Adding peer
{
  echo ""
  echo "[Peer]"
  echo "# Name = ${name}"
  echo "PublicKey = $(cat "${name}.pub")"
  echo "PresharedKey = $(cat "${name}.psk")"
  echo "AllowedIPs = 10.100.0.${ipv4_last_octet}/32, fd08:4711::${ipv6_last_hextet}/128"
} >> /etc/wireguard/wg0.conf

# Reloading server config
wg syncconf wg0 <(wg-quick strip wg0)
