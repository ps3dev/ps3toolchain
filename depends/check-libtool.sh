#!/bin/sh
# check-libtool.sh by Dan Peori (dan.peori@oopo.net)

## Check for libtool.
{ libtool --version || libtool -V; } 1>/dev/null 2>&1 || { echo "ERROR: Install libtool before continuing."; exit 1; }
