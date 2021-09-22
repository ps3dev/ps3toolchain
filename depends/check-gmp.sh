#!/bin/sh
# check-gmp.sh by Timothy Redaelli (timothy@redaelli.eu)

( pkg-config --exists gmp ) || { echo "ERROR: Install gmp before continuing."; exit 1; }
