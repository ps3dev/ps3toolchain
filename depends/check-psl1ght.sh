#!/bin/sh
# check-psl1ght.sh by Dan Peori (danpeori@oopo.net)

## Check if $PSL1GHT is set.
if test ! $PSL1GHT; then { echo "ERROR: Set \$PSL1GHT before continuing."; exit 1; } fi
