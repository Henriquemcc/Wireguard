#!/bin/bash

# Generates client pair of asymmetric keys, IP addresses and its configuration file

# Getting device name
echo -n "Type the device name: "
read -r name

# Getting IPv4 last octet
echo -n "Type the client IPv4 last octet (only decimal numbers, eg. 2): "
read -r ipv4_last_octet

# Getting IPv6 last hextet
echo -n "Type the client IPv6 last hextet (only hexadecimal numbers, eg. 2): "
read -r ipv6_last_hextet

# Getting the endpoint IP Address or hostname
echo -n "Type the endpoint IP address or hostname:"
read -r endpoint_ip_hostname

# Generating client keys
bash ./Generate-ClientKeys.bash "$name"

# Creating client configuration
{
  echo "[Interface]"
  echo "# Name = ${name}"
  echo "Address = 10.100.0.${ipv4_last_octet}/32, fd08:4711::${ipv6_last_hextet}/128"
  echo "DNS = 2606:4700:4700::1112, 2606:4700:4700::1002, 2001:4860:4860::8844, 2001:4860:4860::8888, 2620:119:35::35, 2620:119:53::53, 8.8.8.8, 8.8.4.4, 1.1.1.2, 1.0.0.2, 208.67.222.222, 208.67.220.220"
  echo "PrivateKey = $(cat "${name}.key")"
  echo ""

  echo "[Peer]"
  echo "AllowedIPs = 0.0.0.0/0, ::/0"
  echo "Endpoint = ${endpoint_ip_hostname}:51820"
  echo "PublicKey = $(cat server.pub)"
  echo "PresharedKey = $(cat "${name}.psk")"

} > "${name}.conf"
