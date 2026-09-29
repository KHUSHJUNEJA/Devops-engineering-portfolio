#!/bin/bash

echo "================================"
echo "       SYSTEM INFORMATION"
echo "================================"

echo "Hostname:"
hostname

echo
echo "Operating System:"
cat /etc/os-release | grep PRETTY_NAME

echo
echo "Kernel:"
uname -r

echo
echo "Current User:"
whoami

echo
echo "Uptime:"
uptime

echo
echo "IP Address:"
hostname -I

echo
echo "Disk Usage:"
df -h /

echo
echo "Memory Usage:"
free -h

echo "================================"
