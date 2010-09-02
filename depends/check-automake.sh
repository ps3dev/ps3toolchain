#!/bin/sh
# check-automake.sh by Dan Peori (dan.peori@oopo.net)

## Check for automake.
automake --version 1> /dev/null || { echo "ERROR: Install automake before continuing."; exit 1; }
