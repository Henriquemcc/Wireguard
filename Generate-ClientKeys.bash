#!/bin/bash

# Getting file name
name=$1

# Generating private and public keys
wg genkey | tee "${name}.key" | wg pubkey > "${name}.pub"

# Generating pre-shared key
wg genpsk > "${name}.psk"