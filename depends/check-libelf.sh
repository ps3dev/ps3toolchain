#!/bin/sh
# check-libelf.sh by Dan Peori (dan.peori@oopo.net)

( ls /usr/include/libelf.h || ls /usr/local/include/libelf.h || ls /opt/local/include/libelf.h ) 1>/dev/null 2>&1 || { echo "ERROR: Install libelf before continuing."; exit 1; }
