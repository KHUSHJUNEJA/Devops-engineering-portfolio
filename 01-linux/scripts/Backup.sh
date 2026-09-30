#!/bin/bash

# ============================================================
# BACKUP AUTOMATION SCRIPT
# ============================================================
#
# Purpose:
#   Creates a compressed backup of the Documents directory.
#
# Concepts demonstrated:
#   - Bash variables
#   - Environment variables
#   - Command substitution
#   - Date/time formatting
#   - Conditional statements
#   - Directory existence checks
#   - Exit status codes
#   - tar archives and gzip compression
#   - mkdir
#
# ============================================================


# ------------------------------------------------------------
# 1. DEFINE SOURCE AND BACKUP LOCATIONS
# ------------------------------------------------------------

# $HOME = user's home directory.
# Example: /home/kali
SOURCE="$HOME/Documents"

# Location where backups will be stored.
BACKUP_DIR="$HOME/backups"


# ------------------------------------------------------------
# 2. GENERATE A TIMESTAMP
# ------------------------------------------------------------

# date = displays the current date and time.
#
# +FORMAT = tells date how the output should look.
#
# Example output:
# 2026-09-30_06-50-12
#
# $() = command substitution.
# It runs the command and stores its output in a variable.

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")


# Create the final backup filename.

BACKUP_FILE="$BACKUP_DIR/documents_backup_$TIMESTAMP.tar.gz"


# ------------------------------------------------------------
# 3. CREATE BACKUP DIRECTORY
# ------------------------------------------------------------

# mkdir = create a directory.
#
# -p = create parent directories if required and don't
#      show an error if the directory already exists.

mkdir -p "$BACKUP_DIR"


# ------------------------------------------------------------
# 4. CHECK SOURCE DIRECTORY
# ------------------------------------------------------------

# if = starts a conditional statement.
#
# [ condition ] = tests a condition.
#
# -d = checks whether the specified path is a directory.
#
# ! = NOT.
#
# Therefore:
# [ ! -d "$SOURCE" ]
#
# means:
# "If SOURCE is NOT a directory..."

if [ ! -d "$SOURCE" ]; then

    echo "Error: Source directory does not exist: $SOURCE"

    # exit 1 = stop the script and return status code 1.
    # 0 normally means success.
    # Non-zero values normally indicate an error.

    exit 1
fi


# ------------------------------------------------------------
# 5. CREATE COMPRESSED BACKUP
# ------------------------------------------------------------

# tar = utility for creating and extracting archives.
#
# Options:
#
# -c = create a new archive
# -z = compress using gzip
# -f = specify the output filename
#
# "$BACKUP_FILE" = destination archive.
# "$SOURCE"      = directory being backed up.

tar -czf "$BACKUP_FILE" "$SOURCE"


# ------------------------------------------------------------
# 6. CHECK WHETHER BACKUP SUCCEEDED
# ------------------------------------------------------------

# $? = exit status of the previously executed command.
#
# -eq = numeric "equals".
#
# Therefore:
# [ $? -eq 0 ]
#
# means:
# "Did the previous command finish successfully?"

if [ $? -eq 0 ]; then

    echo "Backup completed successfully."
    echo "Backup file: $BACKUP_FILE"

else

    echo "Backup failed."

    exit 1
fi


# ============================================================
# END OF SCRIPT
# ============================================================
