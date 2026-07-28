#!/bin/bash

# Generating private and public keys
wg genkey | tee server.key | wg pubkey > server.pub