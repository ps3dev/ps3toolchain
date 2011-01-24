#!/bin/sh
# check-bison.sh by Dan Peori (dan.peori@oopo.net)

( bison -V || yacc -V ) 1> /dev/null 2> /dev/null || { echo "ERROR: Install bison before continuing."; exit 1; }
