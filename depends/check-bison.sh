#!/bin/sh
# check-bison.sh by Dan Peori (dan.peori@oopo.net)

## Check for bison.
yacc --version 1> /dev/null || { echo "ERROR: Install bison before continuing."; exit 1; }
