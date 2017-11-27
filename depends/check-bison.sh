#!/bin/sh
# check-bison.sh by Naomi Peori (naomi@peori.ca)

( bison -V || yacc -V ) 1>/dev/null 2>&1 || { echo "ERROR: Install bison before continuing."; exit 1; }
