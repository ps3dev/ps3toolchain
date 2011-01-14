#!/bin/sh
# check-psl1ght.sh by Dan Peori (dan.peori@oopo.net)

## Check if $PSL1GHT is set.
if test ! $PSL1GHT; then { echo "ERROR: Set \$PSL1GHT before continuing."; exit 1; } fi

## Check for the $PSL1GHT directory.
( ls -ld $PSL1GHT || mkdir -p $PSL1GHT ) 1> /dev/null 2> /dev/null || { echo "ERROR: Create $PSL1GHT before continuing."; exit 1; }

## Check for write permission.
touch $PSL1GHT/test.tmp 1> /dev/null || { echo "ERROR: Grant write permissions for $PSL1GHT before continuing."; exit 1; }

## Check for $PSL1GHT/bin in the path.
echo $PATH | grep $PSL1GHT/bin 1> /dev/null || { echo "ERROR: Add $PSL1GHT/bin to your path before continuing."; exit 1; }
