#!/bin/sh
# check-python.sh by Dan Peori (dan.peori@oopo.net)

## Check for python.
( python --version || python -V ) 1> /dev/null 2> /dev/null || { echo "ERROR: Install python before continuing."; exit 1; }

## Check for python header files
( ls /usr/include/python2.*/Python.h || ls /opt/local/include/python2.*/Python.h || ls $PYINSTALLDIR/include/Python.h ) 1> /dev/null 2> /dev/null || { echo "ERROR: Install python-dev before continuing."; exit 1; }
