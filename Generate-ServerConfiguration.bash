#!/bin/bash

# Creating configuration file
{
  echo "[Interface]"
  echo "Address = 10.100.0.1/24, fd08:4711::1/64"
  echo "ListenPort = 51820"
  echo "PostUp = iptables -w -t nat -A POSTROUTING -o $(bash ./Get-DefaultInterfaceIPv4.bash) -j MASQUERADE; ip6tables -w -t nat -A POSTROUTING -o $(bash ./Get-DefaultInterfaceIPv6.bash) -j MASQUERADE"
  echo "PostDown = iptables -w -t nat -D POSTROUTING -o $(bash ./Get-DefaultInterfaceIPv4.bash) -j MASQUERADE; ip6tables -w -t nat -D POSTROUTING -o $(bash ./Get-DefaultInterfaceIPv6.bash) -j MASQUERADE"
} > "wg0.conf"

# Adding private key to the configuration file
echo "PrivateKey = $(cat server.key)" >> "wg0.conf"