#!/bin/sh
# check-ncurses.sh by Naomi Peori (naomi@peori.ca)

( ls /usr/include/ncurses.h || ls /usr/include/ncurses/ncurses.h || ls /opt/local/include/ncurses.h || ls /usr/include/curses.h || ls /mingw/include/curses.h || ls /usr/local/opt/ncurses/include/ncurses.h ) 1>/dev/null 2>&1 || pkg-config --exists ncurses || { echo "ERROR: Install ncurses before continuing."; exit 1; }
