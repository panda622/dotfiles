#!/bin/bash

# Check if a file name is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <file_name> [search_term]"
  exit 1
fi

# Assign the first argument as the file name
FILE_NAME="$1"

# Construct the log file path
LOG_FILE_PATH="~/u3_app/logs/${FILE_NAME}_info.log"

# Assign the second argument as the search term (optional)
SEARCH_TERM="$2"

# Fetch the dynamic IPs of the servers
echo "Fetching server IPs from AWS..."
SERVER_IPS=$(aws --profile=uthrive ec2 describe-instances \
  --filter "Name=tag:aws:autoscaling:groupName,Values=uthrive-scraper-asg" \
  "Name=instance-state-name,Values=running" \
  --query "Reservations[*].Instances[*].NetworkInterfaces[0].PrivateIpAddresses[0].PrivateIpAddress" \
  --output text)

# Check if we got any IPs
if [ -z "$SERVER_IPS" ]; then
  echo "No running servers found. Exiting."
  exit 1
fi

# Iterate over each server IP one by one
for server_ip in $SERVER_IPS; do
  echo "Connecting to $server_ip via bastion..."

  # If no search term is provided, just tail the logs
  if [ -z "$SEARCH_TERM" ]; then
    ssh -o "StrictHostKeyChecking=no" -o "ProxyCommand ssh -o StrictHostKeyChecking=no -i ~/.ssh/uthrive-scraper-bastion-host.pem ec2-user@107.22.70.27 -W %h:%p" \
      -i ~/.ssh/uthrive-scraper.pem ubuntu@"$server_ip" "tail -f $LOG_FILE_PATH"
  else
    # Search for the term in the log file
    result=$(ssh -o "StrictHostKeyChecking=no" -o "ProxyCommand ssh -o StrictHostKeyChecking=no -i ~/.ssh/uthrive-scraper-bastion-host.pem ec2-user@107.22.70.27 -W %h:%p" \
      -i ~/.ssh/uthrive-scraper.pem ubuntu@"$server_ip" "grep '$SEARCH_TERM' $LOG_FILE_PATH")

    # If the search term is found, print it and break the loop
    if [ ! -z "$result" ]; then
      echo "Search term found in logs from $server_ip:"
      echo "$result"
      break
    else
      echo "Search term not found on $server_ip"
    fi
  fi
done

echo "Log fetching complete."
