#!/bin/bash

# Check if an argument is provided
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <s3_path>"
    exit 1
fi

# Assign the first argument to S3_PATH
S3_PATH=$1

# Define the bucket name and AWS profile name
BUCKET_NAME="uthrive-scraper-profiles"
# BUCKET_NAME="uthrive-staging-scraper-profiles"
# BUCKET_NAME="uthrive-staging-merchant-profiles"
AWS_PROFILE="uthrive-scraper"

# Extract the file name from S3_PATH and define local download path
FILENAME=$(basename "$S3_PATH")
LOCAL_DOWNLOAD_PATH="$HOME/Downloads/$FILENAME"

# Download the file from S3 using the specified profile
aws s3 cp "s3://$BUCKET_NAME/$S3_PATH" "$LOCAL_DOWNLOAD_PATH" --profile "$AWS_PROFILE"

echo "Download completed: $LOCAL_DOWNLOAD_PATH"
