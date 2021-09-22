#!/bin/sh
# check-ncurses.sh by Naomi Peori (naomi@peori.ca)

( pkg-config --exists ncurses ) || { echo "ERROR: Install ncurses before continuing."; exit 1; }
