#!/bin/sh
# toolchain-sudo.sh by Naomi Peori (naomi@peori.ca)

## Enter the ps3toolchain directory.
cd "`dirname $0`" || { echo "ERROR: Could not enter the ps3toolchain directory."; exit 1; }

## Set up the environment.
export PS3DEV=/usr/local/ps3dev
export PSL1GHT=$PS3DEV

## Set up the path.
export PATH=$PATH:$PS3DEV/bin
export PATH=$PATH:$PS3DEV/ppu/bin
export PATH=$PATH:$PS3DEV/spu/bin

## Run the toolchain script.
./toolchain.sh $@ || { echo "ERROR: Could not run the toolchain script."; exit 1; }
