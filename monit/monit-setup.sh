#!/bin/bash
sudo apt-get install libwww-perl libdbi-perl libdbd-sqlite3-perl libdatetime-perl
sudo cpan DateTime::Format::ISO8601

if ! which sqlite3; then sudo apt install sqlite3; fi

# init sqlite db
if [ ! -f quicksilver.db ]; then
  echo "CREATE TABLE blockheight (height INTEGER, block_time TEXT);" | sqlite3 quicksilver.db
  echo "INSERT INTO blockheight VALUES (0, '');" | sqlite3 quicksilver.db
fi
