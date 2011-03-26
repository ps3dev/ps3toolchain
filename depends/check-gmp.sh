#!/bin/sh
# check-gmp.sh by Timothy Redaelli (timothy@redaelli.eu)

[ -e /usr/include/gmp.h -o -e /opt/local/include/gmp.h -o -e /usr/local/include/gmp.h ] || { echo "ERROR: Install gmp before continuing."; exit 1; }
