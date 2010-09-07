#!/bin/sh
# check-makeinfo.sh by Dan Peori (dan.peori@oopo.net)

## Check for makeinfo.
makeinfo --version 1> /dev/null || { echo "ERROR: Install makeinfo before continuing."; exit 1; }
