import boto3
import logging

# Configure logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

# Initialize a session using Amazon CloudWatch
client = boto3.client('logs')

# Define the log group and log stream names
# log_group_name = "/aws/batch/job"
log_group_name = "/ecs/uthrive-be-service"
# log_stream_name = "ecs/uthrive-be-service/02dca0f1d3484bd39f53bef85fd0659e"
# log_stream_name = "ecs/uthrive-be-service/b9c1919f34f142949712c6ebd8122a45"
log_stream_name = "ecs/uthrive-be-service/76c22ba25d714eb380cb5cf80ce18c03"

# Fetch log events
def get_all_log_events(log_group_name, log_stream_name):
    events = []
    next_token = None
    last_token = None

    while True:
        logging.info("Fetching log events...")

        if next_token:
            response = client.get_log_events(
                logGroupName=log_group_name,
                logStreamName=log_stream_name,
                nextToken=next_token,
                startFromHead=True
            )
        else:
            response = client.get_log_events(
                logGroupName=log_group_name,
                logStreamName=log_stream_name,
                startFromHead=True
            )

        events_batch = response['events']
        events.extend(events_batch)

        logging.info(f"Fetched {len(events_batch)} events, total so far: {len(events)}")

        # Check if there are more log events to retrieve
        last_token = next_token
        next_token = response.get('nextForwardToken')

        if not events_batch or next_token == last_token:
            logging.info("No more log events to fetch or next token is same as last token.")
            break

    return events

# Save log events to a file
def save_log_events(log_group_name, log_stream_name, events):
    filename = f"{log_group_name.replace('/', '_')}_{log_stream_name.replace('/', '_')}.txt"
    logging.info(f"Saving log events to {filename}")

    with open(filename, "w") as f:
        for event in events:
            f.write(event['message'] + '\n')

    logging.info(f"Saved {len(events)} log events to {filename}")

# Main execution
if __name__ == "__main__":
    logging.info("Script started.")
    events = get_all_log_events(log_group_name, log_stream_name)
    save_log_events(log_group_name, log_stream_name, events)
    logging.info("Script finished.")
