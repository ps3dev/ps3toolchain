#!/bin/sh
# check-libelf.sh by Dan Peori (dan.peori@oopo.net)

if [ ! -f /usr/include/libelf.h ]; then { echo "ERROR: Install libelf before continuing."; exit 1; } fi
