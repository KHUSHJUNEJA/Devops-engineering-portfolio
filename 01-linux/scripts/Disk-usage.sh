#!/bin/bash

echo "================================"
echo "        DISK USAGE REPORT"
echo "================================"

echo
echo "Filesystem Usage:"
df -h

echo
echo "Root Filesystem:"
df -h /

echo
echo "Top-level Directory Sizes:"
du -h --max-depth=1 / 2>/dev/null | sort -h

echo "================================"
