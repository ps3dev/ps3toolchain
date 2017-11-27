#!/bin/sh
# check-psl1ght.sh by Naomi Peori (naomi@peori.ca)

## Check if $PSL1GHT is set.
if test ! $PSL1GHT; then { echo "ERROR: Set \$PSL1GHT before continuing."; exit 1; } fi

## Check for the $PSL1GHT directory.
( ls -ld $PSL1GHT || mkdir -p $PSL1GHT ) 1>/dev/null 2>&1 || { echo "ERROR: Create $PSL1GHT before continuing."; exit 1; }

## Check for write permission.
touch $PSL1GHT/test.tmp 1>/dev/null 2>&1 || { echo "ERROR: Grant write permissions for $PSL1GHT before continuing."; exit 1; }
