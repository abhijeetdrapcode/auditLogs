#!/bin/bash

log_directory="/var/log/mongodb"
output_directory="/home/aman/coding/mongodbauditlogs"
s3_bucket="auditlogs22"

s3_parent_folder="abhijeetauditlogstesting"

mkdir -p "$output_directory"

current_date=$(date +"%Y-%m-%d")
date_folder=$(date +"%d-%m-%Y")
timestamp=$(date +"%H_%M_%S")

output_file="$output_directory/audit_${timestamp}.json"
audit_log_file="$log_directory/audit.json"

if [ ! -f "$audit_log_file" ]; then
    echo "Error: audit.json not found in $log_directory"
    exit 1
fi

echo "Extracting logs for $current_date..."

grep "$current_date" "$audit_log_file" > "$output_file"

if [ ! -s "$output_file" ]; then
    echo "No logs found for today."
    rm -f "$output_file"
    exit 1
fi

echo "Logs saved to $output_file"

s3_path="s3://$s3_bucket/$s3_parent_folder/audit-log/$date_folder/"

echo "Uploading to $s3_path"

aws s3 cp "$output_file" "$s3_path"

if [ $? -eq 0 ]; then
    echo "Upload successful: $output_file → $s3_path"
else
    echo "Upload failed."
    exit 1
fi