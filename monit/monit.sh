#!/bin/bash

# Define the Telegram bot token and chat ID
TELEGRAM_BOT_TOKEN="5640099363:AAHYeYDur-xLjGonNSz1BZAzlwU7iJMErsw"
TELEGRAM_CHAT_ID="17869361"

# Define the RPC endpoint
RPC_ENDPOINT=localhost:36657

# Initialize the database if it doesn't exist
if [ ! -f quicksilver.db ]; then
  echo "CREATE TABLE block_info (block_height INTEGER, block_time TEXT);" | sqlite3 quicksilver.db
  echo "INSERT INTO block_info VALUES (0, '');" | sqlite3 quicksilver.db
fi

# Get the previous block height and time from the database
PREVIOUS_BLOCK_HEIGHT=$(echo "SELECT height FROM blockheight;" | sqlite3 blockheight.db)
PREVIOUS_BLOCK_TIME=$(echo "SELECT block_time FROM blockheight;" | sqlite3 blockheight.db)

# Get the latest block height and time from the RPC endpoint
LATEST_BLOCK_HEIGHT=$(curl -s "$RPC_ENDPOINT/status" | jq .result.sync_info.latest_block_height -r)
LATEST_BLOCK_TIME=$(curl -s "$RPC_ENDPOINT/status" | jq .result.sync_info.latest_block_time -r)

# Check if the block height is increasing
if [ "$LATEST_BLOCK_HEIGHT" -gt "$PREVIOUS_BLOCK_HEIGHT" ]; then
  # Update the previous block height and time in the database
  echo "UPDATE blockheight SET height=$LATEST_BLOCK_HEIGHT, block_time='$LATEST_BLOCK_TIME';" | sqlite3 blockheight.db
  echo "all good"
else
  # Send a Telegram notification
  echo "something bad"
  MESSAGE="⚠️  Quicksilver Mainnet - Tecnodes increasing! Latest block height: $LATEST_BLOCK_HEIGHT. Last block time: $PREVIOUS_B>  URL="https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage?chat_id=$TELEGRAM_CHAT_ID&text=$MESSAGE"
#  curl -s "$URL" >/dev/null
#echo "$URL";
  curl "$URL" 
fi
