#!/bin/sh
#
# check-ps3dev.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

## Check if $PS3DEV is set.
if test ! $PS3DEV; then { echo "ERROR: Set \$PS3DEV before continuing."; exit 1; } fi

## Check for the $PS3DEV directory.
if [ ! -d $PS3DEV ]; then { echo "ERROR: Create $PS3DEV before continuing."; exit 1; } fi

## Check for write permission.
touch $PS3DEV/test.tmp 1>/dev/null 2>&1 || { echo "ERROR: Grant write permissions for $PS3DEV before continuing."; exit 1; }

## Check for $PS3DEV/bin in the path.
echo $PATH | grep $PS3DEV/bin 1>/dev/null 2>&1 || { echo "ERROR: Add $PS3DEV/bin to your path before continuing."; exit 1; }

## Check for $PS3DEV/ppu/bin in the path.
echo $PATH | grep $PS3DEV/ppu/bin 1>/dev/null 2>&1 || { echo "ERROR: Add $PS3DEV/ppu/bin to your path before continuing."; exit 1; }

## Check for $PS3DEV/spu/bin in the path.
echo $PATH | grep $PS3DEV/spu/bin 1>/dev/null 2>&1 || { echo "ERROR: Add $PS3DEV/spu/bin to your path before continuing."; exit 1; }

## Remove test.tmp
if test -f $PS3DEV/test.tmp; then { rm $PS3DEV/test.tmp; } fi
