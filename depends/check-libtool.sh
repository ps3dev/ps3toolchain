#!/bin/sh
# check-libtool.sh by Dan Peori (dan.peori@oopo.net)

## Check for libtool.
{ libtool --version || libtool -V; } 1> /dev/null || { echo "ERROR: Install libtool before continuing."; exit 1; }
