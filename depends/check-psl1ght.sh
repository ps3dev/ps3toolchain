#!/bin/sh
# check-psl1ght.sh by Naomi Peori (naomi@peori.ca)

## Check if $PSL1GHT is set.
[ -z "$PSL1GHT" ] &&
{ echo "ERROR: Set \$PSL1GHT before continuing."; exit 1; }

## Check for the $PSL1GHT directory.
[ -d "$PSL1GHT" ] || mkdir -p "$PSL1GHT" 1>/dev/null 2>&1 ||
{ echo "ERROR: Create \"$PSL1GHT\" before continuing."; exit 1; }

## Check for write permission.
[ -w "$PSL1GHT" ] ||
{ echo "ERROR: Grant write permissions for $PSL1GHT before continuing."; exit 1; }
