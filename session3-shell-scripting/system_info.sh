#!/usr/bin/env bash
# system_info.sh - prints system information and saves process info to a file.
# Usage: ./system_info.sh [output_directory]

set -euo pipefail

# Variables storing system data
current_date=$(date)
host_name=$(hostname)
user_name=$(whoami)

# User input
read -rp "Enter your name: " name
read -rp "Enter your roll number: " roll_no
read -rp "Enter a comment: " comment

# Output directory: first argument, or a predictable default next to the script
output_dir="${1:-./system-info-output}"
mkdir -p "$output_dir"

process_file="$output_dir/process.log"
touch "$process_file"

echo "========== System Information =========="
echo "Date      : $current_date"
echo "Hostname  : $host_name"
echo "Username  : $user_name"
echo
echo "========== Disk Usage =========="
df -h
echo
echo "========== Running Processes =========="
ps
echo
echo "========== Your Details =========="
echo "Name       : $name"
echo "Roll No    : $roll_no"
echo "Comment    : $comment"

# Store running process information in the file using > redirection
ps > "$process_file"
echo
echo "Process information saved to: $process_file"
