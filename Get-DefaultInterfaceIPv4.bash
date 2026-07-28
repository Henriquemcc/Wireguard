#!/bin/bash

command_output="$(ip route list table main default)"
IFS=' '
read -ra ADDR <<< "$command_output"
echo "${ADDR[4]}"