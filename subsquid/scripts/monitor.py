# subsquid worker monitoring from SATMan @ 0xgen - v0.0.1
# pip3 install requests
import requests
import datetime
import time

# Configuration section
JSON_URL = "https://scheduler.testnet.subsquid.io/workers/pings"
PEERS_INFO = [
    ("your_peer_id", "peername_1"),
    ("your_peer_id", "peername_2"),
    ("your_peer_id", "peername_2")
    
    # Add more peers as needed
]
DISCORD_WEBHOOK_URL = "your_discord_webhook"
CHECK_INTERVAL = 600 # Time between checks in seconds

# Function to fetch JSON data from the provided URL
def fetch_json_data(url):
    response = requests.get(url)
    if response.status_code == 200:
        return response.json()
    else:
        print("Failed to fetch data")
        return None

# Function to convert  epoch_seconds to humanreadle time + timezone
def convert_epoch_to_cet_human_readable(last_ping_epoch):
    # Convert epoch time (assumed to be in milliseconds) to seconds
    epoch_seconds = last_ping_epoch / 1000

    # Create a timezone-aware datetime object in UTC
    utc_datetime = datetime.datetime.utcfromtimestamp(epoch_seconds).replace(tzinfo=datetime.timezone.utc)

    # Convert UTC datetime to local time (based on server's timezone settings)
    local_datetime = utc_datetime.astimezone()

    # Format the local datetime as a string (CET or CEST will be shown based on server's timezone and DST settings)
    human_readable_datetime = local_datetime.strftime('%Y-%m-%d %H:%M:%S %Z')

    return human_readable_datetime

# Function to send a Discord notification
def send_discord_notification(webhook_url, message):
    data = {"content": message}
    response = requests.post(webhook_url, json=data)
    if response.status_code == 204:
        print("Notification sent successfully")
    else:
        print("Failed to send notification")

# Main operational function
def check_peers_and_notify():
    data = fetch_json_data(JSON_URL)
    if data is not None:
        current_time = int(time.time() * 1000) # Current time in milliseconds
        for peer_id, peer_name in PEERS_INFO:
            peer_data = next((item for item in data if item["peer_id"] == peer_id), None)
            if peer_data:
                last_ping = peer_data.get("last_ping", 0)
                jailed = peer_data.get("jailed", False)

                human_date = convert_epoch_to_cet_human_readable(last_ping)
                current_human = convert_epoch_to_cet_human_readable(current_time)
                print(f"Node: {peer_name} - Jailed: {jailed} | Last Ping: {human_date} | current time: {current_human} ")

                message = ""
                if current_time - last_ping > 60000: # Check if last ping is more than 60 seconds ago
                    message += f"Peer {peer_name} ({peer_id}) exceeded last ping threshold | Last Ping: {human_date} | current time: {current_human} "
                if jailed:
                    message += f"Peer {peer_name} ({peer_id}) is jailed | Last Ping: {human_date} | current time: {current_human}"

                if message:
                    send_discord_notification(DISCORD_WEBHOOK_URL, message)

# Main function to encapsulate the loop
def main():
    while True:
        try:
            now = datetime.datetime.now()
            current_datetime = now.strftime('%Y-%m-%d %H:%M:%S')
            print(current_datetime)

            check_peers_and_notify()
            print(f"Sleeping {CHECK_INTERVAL} secs")
            print("___________________________________________________________________________")
            time.sleep(CHECK_INTERVAL)
        except Exception as e:
            print(f"An error occurred: {e}")
            time.sleep(60) # Wait a minute before trying again

if __name__ == "__main__":
    main()
