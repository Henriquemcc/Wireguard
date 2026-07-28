#!/bin/bash

# Installs Wireguard to both server and client

# Importing function run_as_root
source ../RunAsRoot.bash

# Running as root
run_as_root

# Installing Wireguard
dnf --assumeyes install wireguard-tools