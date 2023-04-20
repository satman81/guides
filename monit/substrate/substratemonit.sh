#!/bin/bash

ME="INSERT_YOUR_COLLATOR_ADDRESS_HERE"

if echo $ME | grep -qi COLLATOR
then
    echo "please edit this script and set the ME variable to your collator address."
    exit;
fi

if ! which bc 2>/dev/null
    then
        echo "please install bc"
        exit;
fi
if ! sudo apt list --installed 2>/dev/null | grep -qi jq
    then
        echo "please install jq"
        exit;
fi

get_author() {
HEX=$(echo "obase=16; $BLOCK" | bc)
DATA="{\"jsonrpc\":\"2.0\",\"method\":\"eth_getBlockByNumber\",\"params\":[\"0x$HEX\", true],\"id\":1}"
AUTHOR=$(curl --silent -X POST --data  "$DATA" --header 'Content-Type: application/json' localhost:9933 | jq '.result.author' )
}
LC_ME=$(echo "$ME" | tr '[:upper:]' '[:lower:]')
IFS=$'\n'
MINE=0
TOTAL=0
for BLOCK in grep -Eo "Prepared block for proposing at [0-9]+" /var/log/syslog | sed 's/[^0-9]'//g | sort -u
do
MS=$(cat /var/log/syslog | grep "Prepared block for proposing" |  grep $BLOCK | tail -n 1 | cut -f 2 -d "(" | cut -f 1 -d " " )
    get_author
    TOTAL=$(($TOTAL+1))
    if echo $AUTHOR| grep -q "$LC_ME"
        then MINE=$(($MINE+1))
        echo "Success:$BLOCK,$MS"
    else echo "Failure:$BLOCK,$MS"
    fi
#echo $MINE/$TOTAL,$MS
done
SUCCESS=$(echo "scale=2;($MINE/$TOTAL)*100" | bc)
echo "Proposed block success rate is: $SUCCESS%"
