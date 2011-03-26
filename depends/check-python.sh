#!/bin/sh
# check-python.sh by Dan Peori (dan.peori@oopo.net)

## Check for python.
( python --version || python -V ) 1> /dev/null 2> /dev/null || { echo "ERROR: Install python before continuing."; exit 1; }

## Check for python-config
pyprefix=$(python-config --prefix)
[ $? -eq 0 ] || { echo "ERROR: Install python-dev before continuing."; exit 1; }

## Check for python header files
[ -f "${pyprefix}"/include/python2.*/Python.h -o -f /opt/local/include/python2.*/Python.h -o -f $PYINSTALLDIR/include/Python.h ] || { echo "ERROR: Install python-dev before continuing."; exit 1; }
