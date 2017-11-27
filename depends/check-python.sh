#!/bin/sh
# check-python.sh by Naomi Peori (naomi@peori.ca)

## Check for python.
( python --version || python -V ) 1>/dev/null 2>&1 || { echo "ERROR: Install python before continuing."; exit 1; }

## Check for python-config
pyprefix=$(python-config --prefix)
[ $? -eq 0 ] || { echo "ERROR: Install python-dev before continuing."; exit 1; }

## Check for python header files
( ls -1d "${pyprefix}"/include/python2.*/Python.h || ls -1d /opt/local/include/python2.*/Python.h ) 1>/dev/null 2>&1 || [ -f "$PYINSTALLDIR/include/Python.h" ] || { echo "ERROR: Install python-dev before continuing."; exit 1; }
