#!/bin/sh
# check-gmp.sh by Timothy Redaelli (timothy@redaelli.eu)

[ -f /usr/include/$(gcc -dumpmachine)/gmp.h -o -f /usr/include/gmp.h -o -f /opt/local/include/gmp.h -o -f /usr/local/include/gmp.h -o -f /opt/csw/include/gmp.h ] || pkg-config --exists gmp || { echo "ERROR: Install gmp before continuing."; exit 1; }
