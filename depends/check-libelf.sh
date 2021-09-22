#!/bin/sh
# check-libelf.sh by Naomi Peori (naomi@peori.ca)

( ls /usr/include/libelf.h || ls /usr/local/include/libelf.h || ls /opt/local/include/libelf.h || ls /opt/local/include/libelf/libelf.h || ls /usr/local/include/libelf/libelf.h ) 1>/dev/null 2>&1 || pkg-config --exists libelf || { echo "ERROR: Install libelf before continuing."; exit 1; }
