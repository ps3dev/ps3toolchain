#!/bin/sh
# check-zlib.sh by Naomi Peori (naomi@peori.ca)

( pkg-config --exists zlib ) || { echo "ERROR: Install zlib before continuing."; exit 1; }
