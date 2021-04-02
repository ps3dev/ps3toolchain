#!/bin/sh
# check-ps3dev.sh by Naomi Peori (naomi@peori.ca)

## Check if $PS3DEV is set.
[ -z "$PS3DEV" ] &&
{ echo "ERROR: Set \$PS3DEV before continuing."; exit 1; }

## Check for the $PS3DEV directory.
[ -d "$PS3DEV" ] || mkdir -p "$PS3DEV" 1>/dev/null 2>&1 ||
{ echo "ERROR: Create \"$PS3DEV\" before continuing."; exit 1; }

## Check for write permission.
[ -w "$PS3DEV" ] ||
{ echo "ERROR: Grant write permissions for \"$PS3DEV\" to $USER before continuing."; exit 1; }

## Check for $PS3DEV/bin in the path.
echo ":$PATH:" | grep ":$PS3DEV/bin:" 1>/dev/null 2>&1 ||
{ echo "ERROR: Add \"$PS3DEV/bin\" to your path before continuing."; exit 1; }

## Check for $PS3DEV/ppu/bin in the path.
echo ":$PATH:" | grep ":$PS3DEV/ppu/bin:" 1>/dev/null 2>&1 ||
{ echo "ERROR: Add \"$PS3DEV/ppu/bin\" to your path before continuing."; exit 1; }

## Check for $PS3DEV/spu/bin in the path.
echo ":$PATH:" | grep ":$PS3DEV/spu/bin:" 1>/dev/null 2>&1 ||
{ echo "ERROR: Add \"$PS3DEV/spu/bin\" to your path before continuing."; exit 1; }
