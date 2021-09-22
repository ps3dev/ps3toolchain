#!/bin/sh
# check-zlib.sh by Naomi Peori (naomi@peori.ca)

( ls /usr/include/zlib.h || ls /opt/local/include/zlib.h || ls /usr/local/opt/zlib/include/zlib.h ) 1>/dev/null 2>&1 || pkg-config --exists zlib || { echo "ERROR: Install zlib before continuing."; exit 1; }
