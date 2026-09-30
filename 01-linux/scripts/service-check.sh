#!/bin/bash

# ============================================================
# LINUX SERVICE HEALTH CHECKER
# ============================================================
#
# Purpose:
#   Checks whether a Linux service is running.
#
# Concepts demonstrated:
#   - Bash variables
#   - Command-line arguments
#   - systemctl
#   - Conditional statements
#   - Exit status
#   - Service monitoring
#
# Usage:
#   ./service-check.sh ssh
#
# ============================================================


# ------------------------------------------------------------
# 1. CHECK WHETHER A SERVICE NAME WAS PROVIDED
# ------------------------------------------------------------

# $1 = first command-line argument.
#
# Example:
#   ./service-check.sh ssh
#
# $1 will contain:
#   ssh

SERVICE="$1"


# $# = number of command-line arguments provided.
#
# If $# is 0, no service name was provided.

if [ $# -eq 0 ]; then
    echo "Usage: $0 <service-name>"
    exit 1
fi


# ------------------------------------------------------------
# 2. CHECK SERVICE STATUS
# ------------------------------------------------------------

# systemctl = command used to manage and inspect
# systemd services.
#
# is-active = checks whether the service is currently active.
#
# --quiet = suppresses normal output.
#
# The command's exit status tells us whether the service
# is active.

systemctl is-active --quiet "$SERVICE"


# ------------------------------------------------------------
# 3. CHECK THE RESULT
# ------------------------------------------------------------

# $? = exit status of the previous command.
#
# 0 = success
# non-zero = failure

if [ $? -eq 0 ]; then

    echo "================================"
    echo "SERVICE HEALTH CHECK"
    echo "================================"
    echo "Service : $SERVICE"
    echo "Status  : RUNNING"
    echo "================================"

else

    echo "================================"
    echo "SERVICE HEALTH CHECK"
    echo "================================"
    echo "Service : $SERVICE"
    echo "Status  : NOT RUNNING"
    echo "================================"

fi
