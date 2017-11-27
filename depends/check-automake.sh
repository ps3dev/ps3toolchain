#!/bin/sh
# check-automake.sh by Naomi Peori (naomi@peori.ca)

## Check for automake.
automake --version 1>/dev/null 2>&1 || { echo "ERROR: Install automake before continuing."; exit 1; }
