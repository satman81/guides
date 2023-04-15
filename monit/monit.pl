#!/usr/bin/perl
use strict;
use warnings;
use LWP::UserAgent;
use DBI;
#use DateTime;
use DateTime::Format::ISO8601; 

# Configuration
my $DB_FILE = "quicksilver.db";
my $TELEGRAM_BOT_TOKEN = "5640099363:AAHYeYDur-xLjGonNSz1BZAzlwU7iJMErsw";
my $TELEGRAM_CHAT_ID = "17869361";
my $RPC_ENDPOINT = "http://localhost:36657"; # Replace with your RPC endpoint

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
my $sth = $dbh->prepare("SELECT block_height, block_time FROM block_info ORDER BY block_height DESC LIMIT 1");
$sth->execute;
my $row = $sth->fetchrow_arrayref;
my $prev_block_height = $row ? $$row[0] : "";
my $prev_block_time = $row && defined $$row[1] ? $$row[1] : "";

#my $prev_block_height = $row ? $$row[0] : "";
#my $prev_block_time = $row ? $$row[1] : "";

#print "RPC Block height: $latest_block_height at $latest_block_time\n";
#print "DB Block height:  $prev_block_height at $prev_block_time\n";


# Format Latest  block time
my $latest_block_time_dt = DateTime->from_epoch(epoch => DateTime::Format::ISO8601->parse_datetime($latest_block_time)->epoch);
my $latest_block_time_formatted = $latest_block_time_dt->strftime("%d.%m.%Y %H:%M:%S");

# Calculate time difference
my $now_dt = DateTime->now();
my $time_diff = $now_dt->epoch() - $latest_block_time_dt->epoch();
my $time_diff_formatted = sprintf("%.0f mins ago", $time_diff / 60);



if ($latest_block_height > $prev_block_height) {
    #print "Block height increased to $latest_block_height at $latest_block_time_formatted it's about: $time_diff_formatted\n";
    $dbh->do("INSERT INTO block_info (block_height, block_time) VALUES (?, ?)", undef, $latest_block_height, $latest_block_time);

} else {
    # Send Telegram notification
    print "Warning: Block height has not increased since $prev_block_time!";

    my $message = "⚠️  Warning: Quicksilver Mainnet | Tecnodes\n"
	. "Blocks not increasing\n"
	. "Block Height: $latest_block_height\n"
	. "Block Time: $latest_block_time_formatted ($time_diff_formatted)";

    my $telegram_api = "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage?chat_id=$TELEGRAM_CHAT_ID&text=$message";
    $ua->get($telegram_api);
}
#=cut

# Disconnect from database
$sth->finish();
#$sth_insert->finish();
$dbh->disconnect;
