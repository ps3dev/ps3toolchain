#!/bin/sh
# check-make.sh by Naomi Peori (naomi@peori.ca)

## Check for make.
${MAKE:-make} -v 1>/dev/null 2>&1 || { echo "ERROR: Install make before continuing."; exit 1; }
