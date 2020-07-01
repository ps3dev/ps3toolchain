#!/bin/sh
# check-gmp.sh by Timothy Redaelli (timothy@redaelli.eu)
set -x

([ -f /usr/include/$(gcc -dumpmachine)/gmp.h ] || [ -f /usr/include/gmp.h ] || [ -f /opt/local/include/gmp.h ] || [ -f /usr/local/include/gmp.h ] || [ -f /opt/csw/include/gmp.h ]) || { echo "ERROR: Install gmp before continuing."; exit 1; }
