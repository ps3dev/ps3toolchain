#!/bin/sh
# check-ncurses.sh by Dan Peori (dan.peori@oopo.net)

( ls /usr/include/ncurses.h || ls /usr/include/ncurses/ncurses.h || ls /opt/local/include/ncurses.h || ls /usr/include/curses.h ) 1> /dev/null 2> /dev/null || { echo "ERROR: Install ncurses before continuing."; exit 1; }
