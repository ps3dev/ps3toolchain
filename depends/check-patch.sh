#!/bin/sh
# check-patch.sh by Dan Peori (dan.peori@oopo.net)

## Check for patch.
patch -v 1>/dev/null 2>&1 || { echo "ERROR: Install patch before continuing."; exit 1; }
