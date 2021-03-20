#!/bin/sh
# check-ncurses.sh by Naomi Peori (naomi@peori.ca)

[ -f /usr/include/ncurses.h ] ||
[ -f /usr/include/ncurses/ncurses.h ] ||
[ -f /opt/local/include/ncurses.h ] ||
[ -f /usr/include/curses.h ] ||
[ -f /mingw/include/curses.h ] ||
[ -f /usr/local/opt/ncurses/include/ncurses.h ] ||
{ echo "ERROR: Install ncurses before continuing."; exit 1; }
# sudo apt-get install libncurses5-dev