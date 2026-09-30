#!/bin/bash

echo "================================"
echo "        MEMORY USAGE REPORT"
echo "================================"

echo
echo "Memory Usage:"
free -h

echo
echo "Memory Statistics:"
cat /proc/meminfo | head -10

echo
echo "Top Processes by Memory Usage:"
ps aux --sort=-%mem | head -10

echo "================================"
