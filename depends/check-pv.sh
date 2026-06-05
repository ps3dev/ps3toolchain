#!/bin/sh

( pv -V ) 1>/dev/null 2>&1 || { echo "ERROR: Install pv before continuing."; exit 1; }
