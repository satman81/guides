import subprocess
import json
import os
import datetime

# Function to get chain height
def get_chain_height(port):
    try:
        cmd = f'curl -s  http://127.0.0.1:{port}  -X POST -H "Content-Type: application/json" -d \'{{"jsonrpc":"2.0","method":"quai_blockNumber","params":[],"id":0}}\' | jq -r .result'
        result = subprocess.check_output(cmd, shell=True).decode('utf-8').strip()
        return int(result, 16)  # Assuming the result is in hexadecimal
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

# Function to read previous data
def read_previous_data(filename):
    if os.path.exists(filename):
        with open(filename, 'r') as f:
            return json.load(f)
    else:
        return None

# Function to write current data
def write_current_data(filename, data):
    with open(filename, 'w') as f:
        json.dump(data, f)

# Main script
if __name__ == "__main__":
    filename = "previous_data.json"
    previous_data = read_previous_data(filename)

    # Current data
    current_time = datetime.datetime.now()
    chains = {
        "Prime": 8546,
        "Cyprus": 8578,
        "Cyprus1": 8610,
        "Cyprus2": 8542,
        "Cyprus3": 8674,
        "Paxos": 8580,
        "Paxos1": 8512,
        "Paxos2": 8544,
        "Paxos3": 8576,
        "Hydra": 8582,
        "Hydra1": 8614,
        "Hydra2": 8646,
        "Hydra3": 8678
    }
    current_data = {"timestamp": current_time.strftime('%Y-%m-%d %H:%M:%S'), "block_heights": {}}

    for name, port in chains.items():
        current_data["block_heights"][name] = {"port": port, "height": get_chain_height(port)}

    # Display and compare data
    if previous_data:
        previous_time = datetime.datetime.strptime(previous_data["timestamp"], '%Y-%m-%d %H:%M:%S')
        time_difference = current_time - previous_time
        print(f"Script running after {time_difference}")

        for name, data in current_data["block_heights"].items():
            port = data["port"]
            height = data["height"]
            if name in previous_data["block_heights"]:
                block_difference = height - previous_data["block_heights"][name]["height"]
                print(f"{name} ({port}) block count increased by {block_difference}     - Current Block ({height})")
            else:
                print(f"{name} ({port}) data not available in previous run.")
    else:
        print("This is the first run of the script.")

    # Write current data to file
    write_current_data(filename, current_data)
# external RPC:
# https://rpc.paxos1.colosseum.quaiscan.io/
# https://rpc.paxos2.colosseum.quaiscan.io/
# https://rpc.paxos3.colosseum.quaiscan.io/

# https://rpc.hydra1.colosseum.quaiscan.io
# https://rpc.hydra2.colosseum.quaiscan.io
# https://rpc.hydra3.colosseum.quaiscan.io

# https://rpc.cyprus1.colosseum.quaiscan.io
# https://rpc.cyprus2.colosseum.quaiscan.io
# https://rpc.cyprus3.colosseum.quaiscan.io
