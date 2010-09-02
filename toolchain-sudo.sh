#!/bin/bash
# toolchain-sudo.sh by Dan Peori (dan.peori@oopo.net)

## Enter the ps3toolchain directory.
cd "`dirname $0`" || { echo "ERROR: Could not enter the ps3toolchain directory."; exit 1; }

## Set up the environment.
export PS3DEV=/usr/local/ps3dev
export PATH=$PATH:$PS3DEV/bin
export PATH=$PATH:$PS3DEV/ppu/bin
export PATH=$PATH:$PS3DEV/spu/bin

## Run the toolchain script.
./toolchain.sh $@ || { echo "ERROR: Could not run the toolchain script."; exit 1; }
