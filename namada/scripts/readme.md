# Namada Block Signatures Checker

The Block Signatures Checker is a Bash script that allows you to analyze block signatures of validators in a specified range of block heights of namada's current testnet. It provides information on how many blocks each validator has signed and how many they have missed within the given range.

## Prerequisites

- Bash
- curl
- jq (a lightweight and flexible command-line JSON processor)

## Usage

To use the Block Signatures Checker, follow these steps:

1. Clone the repository or download the script to your local machine.

2. Make the script executable:

   ```bash
   chmod +x blocksign.sh

3. configure the following variables

  ```bash
  rpc_url="http://localhost:26657" 
  blocks_to_scan=50
  ````

4. if you are running the script on the same machine where your namada node is running then you can simply execute it without any parameter, by default script will fetch the latest block and will scan last 50 blocks to find your block signature

  ```bash
  ./blocksign.sh
  ```

5. alternatively you can pass single or multiple comma-separated validator addresses
  ```
  ./blocksign.sh D5367D670153ABAAEA2A5FFD8FD3E329B4CF16A0,75EEF5D9E3DBEC70B45A5819254090D7EDBFB317
  ```
6. sample output

  ```
  Scanning Blocks... [50/50]
  Validator Address: D5367D670153ABAAEA2A5FFD8FD3E329B4CF16A0 - Signed: 0, Missed: 50, Ratio: 0%
  Validator Address: 75EEF5D9E3DBEC70B45A5819254090D7EDBFB317 - Signed: 50, Missed: 0, Ratio: 100%
  Start Block: 123906 | End Block: 123956
  ```
8. quick exeuction
  ```
  wget url.com
  ``` 


