#!/bin/sh
# check-libelf.sh by Naomi Peori (naomi@peori.ca)

[ -f /usr/include/libelf.h ] ||
[ -f /usr/local/include/libelf.h ] ||
[ -f /opt/local/include/libelf.h ] ||
[ -f /opt/local/include/libelf/libelf.h ] ||
[ -f /usr/local/include/libelf/libelf.h ] ||
{ echo "ERROR: Install libelf before continuing."; exit 1; }