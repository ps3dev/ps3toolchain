#!/bin/sh
#
# check-psl1ght.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

## Check if $PSL1GHT is set.
if test ! $PSL1GHT; then { echo "ERROR: Set \$PSL1GHT before continuing."; exit 1; } fi

## Check for the $PSL1GHT directory.
if [ ! -d $PSL1GHT ]; then { echo "ERROR: Create $PSL1GHT before continuing."; exit 1; } fi

## Check for write permission.
touch $PSL1GHT/test.tmp 1>/dev/null 2>&1 || { echo "ERROR: Grant write permissions for $PSL1GHT before continuing."; exit 1; }

## Remove test.tmp
if test -f $PSL1GHT/test.tmp; then { rm $PSL1GHT/test.tmp; } fi
