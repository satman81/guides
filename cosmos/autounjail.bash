#automatically restart the service and unjail a cosmos based node, if blocks are not syncing and/or voting power == 0
import requests
import json
import time
import subprocess
import datetime
import discord
import getpass

# ***** Configuration *****
rpc_url = "http://localhost:26657"
wallet_name = "your key"  
systemd_service = "giad.service"
node_binary = "giad"
is_validator = True  
discord_webhook_url = "discord_web_hook_url"

# ***** Helper Functions *****
def check_block_production(rpc_url):
    try:
        response = requests.get(f"{rpc_url}/status")
        response.raise_for_status()  # Raise an error if request failed
        data = response.json()
        latest_block_time = data['result']['sync_info']['latest_block_time']

        # Truncate the timestamp to microsecond precision (6 digits)
        if '.' in latest_block_time:
            parts = latest_block_time.split('.')
            truncated_timestamp = parts[0] + '.' + parts[1][:6] + 'Z'
        else:
            truncated_timestamp = latest_block_time

        # Convert latest_block_time (adjusted ISO 8601 format) to a datetime object in UTC
        latest_block_datetime_utc = datetime.datetime.strptime(truncated_timestamp, "%Y-%m-%dT%H:%M:%S.%fZ").replace(tzinfo=datetime.timezone.utc)
        
        # Convert UTC datetime to server's local time zone
        server_local_time = datetime.datetime.now().astimezone()
        latest_block_datetime_local = latest_block_datetime_utc.astimezone(server_local_time.tzinfo)

        print(f"Latest Block Time (Local): {latest_block_datetime_local}")

        # Calculate time difference between now and the latest block time in local server time
        time_difference = server_local_time - latest_block_datetime_local
        print(f"Time Difference: {time_difference} ({time_difference.total_seconds()} seconds)")

        # Check if the latest block time is within 5 minutes of the current server time
        return time_difference.total_seconds() < 300  # 5 minutes threshold
    except Exception as e:
        print(f"Error: {e}")  # Printing error for debugging
        return False

def restart_service(service_name):
    subprocess.run(["systemctl", "restart", service_name])
    print(f"Block were not processing, restarting service: {service_name}")  

def unjail_node(node_binary, wallet_name, wallet_password):

    send_discord_notification(discord_webhook_url,"Pathrock Monitoring: Blockx Mainnet Jailed detected, attempting to unjail..")
    command = "echo '{}' | blockxd tx slashing unjail --from {} -y".format(wallet_password, wallet_name)

    #print(f"command: {command}")

    process = subprocess.run(command, shell=True, text=True, capture_output=True)

    print("STDOUT:", process.stdout)
    print("STDERR:", process.stderr)    

def send_discord_notification(webhook_url, message):
    data = {"content": message}
    requests.post(webhook_url, data=data)
    print(message)  

def check_voting_power(rpc_url, wallet_name):
    try:
        # Replace with your Cosmos-specific RPC endpoint for validator queries        
        response = requests.get(f"{rpc_url}/status")
        response.raise_for_status()
        data = response.json()
        # Extract voting power from the response (structure might vary)
        voting_power = int(data['result']['validator_info']['voting_power']) 
        print(f"Voting power: {voting_power}")  
        return voting_power
    except Exception as e:
        print(f"Error checking voting power: {e}")
        return 0

# ***** Main Logic *****
def main():    
    wallet_password = getpass.getpass("Wallet Password: ")

    while True:
        try:
            blocks_producing = check_block_production(rpc_url)
            print("Checking block production...")  
            if not blocks_producing:
                restart_service(systemd_service)
                send_discord_notification(discord_webhook_url,"Pathrock Monitoring: Blockx Mainnet Node not producing blocks, service restart attempted.")

            if blocks_producing and is_validator:
                voting_power = check_voting_power(rpc_url, wallet_name)       

                needs_unjail = voting_power == 0
                if needs_unjail:                    
                    unjail_node(node_binary, wallet_name, wallet_password)
                    send_discord_notification(discord_webhook_url, "Pathrock Monitoring: Blockx Mainnet unjailed executed, please verify...")

        except Exception as e:
            send_discord_notification(discord_webhook_url, f"Error: {e}")

        print("Sleeping 30 mins...")
        print("------------------------------------------------------------------")
        time.sleep(600)

if __name__ == "__main__":
    main()
