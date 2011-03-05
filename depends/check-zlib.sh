#!/bin/sh
# check-zlib.sh by Dan Peori (dan.peori@oopo.net)

( ls /usr/include/zlib.h || ls /opt/local/include/zlib.h || ls $PS3DEV/include/zlib.h ) 1> /dev/null 2> /dev/null || { echo "ERROR: Install zlib before continuing."; exit 1; }
