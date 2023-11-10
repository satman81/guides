# Namada Block Sign Checker

The Namada Block Sign Checker is a Bash script designed for analyzing block signatures of validators in the `Namada testnet`. This script allows you to evaluate how many blocks each validator has signed and how many they have missed within a specified range of block heights.

## Prerequisites

- Bash
- curl
- jq (a lightweight and flexible command-line JSON processor)

## Usage

To use the Block Sign Checker, follow these steps:

1. Clone the repository or download the script to your local machine.

2. Make the script executable:

   ```bash
   chmod +x blocksign.sh

3. configure the following variables

  ```bash
  rpc_url="http://localhost:26657" 
  blocks_to_scan=50
  ````

4. If you are running the script on the same machine where your Namada node is located, you can execute it without any parameters. By default, the script will fetch the latest block and scan the last 50 blocks to find block signatures:

  ```bash
  ./blocksign.sh
  ```

5. Alternatively, you can pass one or more comma-separated validator addresses as arguments:
  ```
  ./blocksign.sh D5367D670153ABAAEA2A5FFD8FD3E329B4CF16A0,75EEF5D9E3DBEC70B45A5819254090D7EDBFB317
  ```
6. sample output

  ```bash
  Scanning Blocks... [50/50]
  Validator Address: D5367D670153ABAAEA2A5FFD8FD3E329B4CF16A0 - Signed: 0, Missed: 50, Ratio: 0%
  Validator Address: 75EEF5D9E3DBEC70B45A5819254090D7EDBFB317 - Signed: 50, Missed: 0, Ratio: 100%
  Start Block: 123906 | End Block: 123956
  ```
  
7. For live execution directly from this GitHub repository, you can use the following commands:
```
curl -sL "https://raw.githubusercontent.com/satman81/guides/main/namada/scripts/blocksign.sh" | bash -s --
```
With validator addresses as arguments:
```
curl -sL "https://raw.githubusercontent.com/satman81/guides/main/namada/scripts/blocksign.sh" | bash -s -- D5367D670153ABAAEA2A5FFD8FD3E329B4CF16A0,75EEF5D9E3DBEC70B45A5819254090D7EDBFB317
```


