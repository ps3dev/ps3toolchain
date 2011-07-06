#!/bin/sh
# check-make.sh by Dan Peori (dan.peori@oopo.net)

## Check for make.
${MAKE:-make} -v 1>/dev/null 2>&1 || { echo "ERROR: Install make before continuing."; exit 1; }
