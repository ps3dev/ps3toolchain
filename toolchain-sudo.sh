#!/bin/sh
#
# toolchain-sudo.sh by Naomi Peori (naomi@peori.ca)

## Enter the ps3toolchain directory.
cd "`dirname $0`" || { echo "ERROR: Could not enter the ps3toolchain directory."; exit 1; }

## Run the toolchain script.
./toolchain.sh $@ || { echo "ERROR: Could not run the toolchain script."; exit 1; }
