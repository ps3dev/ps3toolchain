#!/bin/sh
# check-gcc.sh by Dan Peori (dan.peori@oopo.net)

## Check for gcc.
gcc --version 1>/dev/null 2>&1 || { echo "ERROR: Install gcc before continuing."; exit 1; }
