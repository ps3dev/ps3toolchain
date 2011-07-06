#!/bin/sh
# check-pkg-config.sh by Dan Peori (dan.peori@oopo.net)

## Check for pkg-config.
pkg-config --version 1>/dev/null 2>&1 || { echo "ERROR: Install pkg-config before continuing."; exit 1; }
