#!/bin/sh
# check-python.sh by Naomi Peori (naomi@peori.ca)

## Check for python.
( python --version || python -V ) 1>/dev/null 2>&1 || { echo "ERROR: Install python before continuing."; exit 1; }

## Check for python-config
if command -v python-config >/dev/null 2>&1; then
  pyprefix=$(python-config --prefix)
elif command -v python3-config >/dev/null 2>&1; then
  pyprefix=$(python3-config --prefix)
else
  echo "Neither python-config nor python3-config found" >&2
  exit 1
fi

## Check for python header files
( ls -1d "${pyprefix}"/include/python[23].*/Python.h || ls -1d /opt/local/include/python[23].*/Python.h ) 1>/dev/null 2>&1 || [ -f "$PYINSTALLDIR/include/Python.h" ] || { echo "ERROR: Install python-dev before continuing."; exit 1; }
