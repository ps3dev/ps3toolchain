#!/bin/sh
# check-bison.sh by Dan Peori (dan.peori@oopo.net)

( bison -V || yacc -V ) 1>/dev/null 2>&1 || { echo "ERROR: Install bison before continuing."; exit 1; }
