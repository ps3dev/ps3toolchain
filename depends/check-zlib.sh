#!/bin/sh
# check-zlib.sh by Naomi Peori (naomi@peori.ca)

[ -f /usr/include/zlib.h ] ||
[ -f /opt/local/include/zlib.h ] ||
[ -f /usr/local/opt/zlib/include/zlib.h ] ||
{ echo "ERROR: Install zlib before continuing."; exit 1; }
# sudo apt-get install zlib1g-dev