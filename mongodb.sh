#!/bin/bash

log_directory="/var/log/mongodb"
output_directory="/home/aman/coding/mongodbauditlogs"

# Create output directory if not exists
mkdir -p "$output_directory"

# Generate timestamp for filename
current_date=$(date +"%Y-%m-%d")
timestamp=$(date +"%H_%M_%S")

output_file="$output_directory/audit_${timestamp}.json"

# Check if audit log exists
audit_log_file="$log_directory/audit.json"

if [ ! -f "$audit_log_file" ]; then
    echo "Error: audit.json not found in $log_directory"
    exit 1
fi

echo "Extracting logs for $current_date..."

# Extract only today's logs (JSON lines)
grep "$current_date" "$audit_log_file" > "$output_file"

# Validate if file has content
if [ ! -s "$output_file" ]; then
    echo "No logs found for today."
    rm -f "$output_file"
    exit 1
fi

echo "Logs saved to $output_file"