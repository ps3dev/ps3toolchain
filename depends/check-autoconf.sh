#!/bin/sh
# check-autoconf.sh by Dan Peori (dan.peori@oopo.net)

## Check for autoconf.
autoconf --version 1>/dev/null 2>&1|| { echo "ERROR: Install autoconf before continuing."; exit 1; }
