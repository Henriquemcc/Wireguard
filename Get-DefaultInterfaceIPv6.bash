#!/bin/bash

command_output="$(ip -6 route list table main default)"
IFS=' '
read -ra ADDR <<< "$command_output"
echo "${ADDR[4]}"