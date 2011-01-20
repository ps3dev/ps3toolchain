#!/bin/bash
# toolchain-sudo.sh by Dan Peori (dan.peori@oopo.net)

## Enter the ps3toolchain directory.
cd "`dirname $0`" || { echo "ERROR: Could not enter the ps3toolchain directory."; exit 1; }

## Set up the PS3DEV environment.
export PS3DEV=/usr/local/ps3dev
export PATH=$PATH:$PS3DEV/bin
export PATH=$PATH:$PS3DEV/host/ppu/bin
export PATH=$PATH:$PS3DEV/host/spu/bin

## Set up the PSL1GHT environment.
export PSL1GHT=$PS3DEV/psl1ght
export PATH=$PATH:$PSL1GHT/host/bin

## Run the toolchain script.
./toolchain.sh $@ || { echo "ERROR: Could not run the toolchain script."; exit 1; }
