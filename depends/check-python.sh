#!/bin/sh
# check-python.sh by Dan Peori (dan.peori@oopo.net)

## Check for python.
python --version 1> /dev/null || { echo "ERROR: Install python before continuing."; exit 1; }
