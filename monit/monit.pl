#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use DBI;

# Configuration
my $DB_FILE = "block_info.db";
my $TELEGRAM_BOT_TOKEN = "YOUR_BOT_TOKEN_HERE";
my $TELEGRAM_CHAT_ID = "YOUR_CHAT_ID_HERE";
my $RPC_ENDPOINT = "http://localhost:26657"; # Replace with your RPC endpoint

# Connect to database
my $dbh = DBI->connect("dbi:SQLite:dbname=$DB_FILE","","") or die "Could not open database";

# Get current block height and time from RPC
my $ua = LWP::UserAgent->new;
$ua->agent("Mozilla/5.0");
my $response = $ua->get("$RPC_ENDPOINT/status");
my $json = $response->content;
my $latest_block_height = $json =~ /"latest_block_height":"(\d+)"/ ? $1 : "";
my $latest_block_time = $json =~ /"latest_block_time":"([^"]+)"/ ? $1 : "";

# Check if block height has increased
my $sth = $dbh->prepare("SELECT * FROM block_info ORDER BY id DESC LIMIT 1");
$sth->execute;
my $row = $sth->fetchrow_arrayref;
my $prev_block_height = $row ? $$row[1] : "";
my $prev_block_time = $row ? $$row[2] : "";

if ($latest_block_height > $prev_block_height) {
    print "Block height increased to $latest_block_height at $latest_block_time\n";
    $dbh->do("INSERT INTO block_info (block_height, block_time) VALUES (?, ?)", undef, $latest_block_height, $latest_block_time);

} else {
    # Send Telegram notification
    print "Warning: Block height has not increased since $prev_block_time!";
    my $message = "Warning: Block height has not increased since $prev_block_time!";
    my $telegram_api = "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage?chat_id=$TELEGRAM_CHAT_ID&text=$message";
    $ua->get($telegram_api);
}

# Disconnect from database
$dbh->disconnect;
