#!/bin/sh
# check-python.sh by Naomi Peori (naomi@peori.ca)
#TODO: Do we need to differentiate python2 and 3? Python2 is EOL

## Check for python.
( python --version || python -V ) 1>/dev/null 2>&1 ||
{ echo "ERROR: Install python before continuing."; exit 1; }
# sudo apt-get install python2.7

## Check for python-config
PYPREFIX=$(python-config --prefix)
[ -z "$PYPREFIX" ] && { echo "ERROR: Install python-dev before continuing."; exit 1; }
# sudo apt-get install python2-config

## Check for python header files
ls -1d "${PYPREFIX}"/include/python2.*/Python.h 1>/dev/null 2>&1 ||
ls -1d /opt/local/include/python2.*/Python.h 1>/dev/null 2>&1 ||
[ -f "$PYINSTALLDIR/include/Python.h" ] ||
{ echo "ERROR: Install python-dev before continuing."; exit 1; }
# sudo apt-get install python2.7-dev