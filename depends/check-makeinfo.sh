#!/bin/sh
# check-makeinfo.sh by Naomi Peori (naomi@peori.ca)

## Check for makeinfo.
makeinfo --version 1>/dev/null 2>&1 || { echo "ERROR: Install makeinfo before continuing."; exit 1; }
