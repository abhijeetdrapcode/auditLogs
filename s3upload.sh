#!/bin/bash

s3_bucket="auditlogs22"
folder_to_copy="/home/aman/coding/mongodbauditlogs"

# IMPORTANT: this should match your backend env
# process.env.AUDIT_LOG_S3_FOLDER
s3_parent_folder="abhijeetTesting"   # <-- CHANGE THIS

current_dir=$(dirname "$0")
cd "$current_dir" || exit 1

# Run mongodb.sh
if [ -x "./mongodb.sh" ]; then
    echo "Executing mongodb.sh..."
    ./mongodb.sh
else
    echo "Error: mongodb.sh is not executable. Run: chmod +x mongodb.sh"
    exit 1
fi

# Get latest generated JSON file
latest_file=$(ls -t "$folder_to_copy"/audit_*.json 2>/dev/null | head -n 1)

if [ -z "$latest_file" ]; then
    echo "No JSON file found to upload."
    exit 1
fi

# Create date folder (DD-MM-YYYY)
date_folder=$(date +"%d-%m-%Y")

# Final S3 path
s3_path="s3://$s3_bucket/$s3_parent_folder/audit-log/$date_folder/"

echo "Uploading $latest_file to $s3_path"

aws s3 cp "$latest_file" "$s3_path"

if [ $? -eq 0 ]; then
    echo "Upload successful: $latest_file → $s3_path"
else
    echo "Upload failed."
    exit 1
fi