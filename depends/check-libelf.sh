#!/bin/sh
# check-libelf.sh by Naomi Peori (naomi@peori.ca)

( pkg-config --exists libelf ) || { echo "ERROR: Install libelf before continuing."; exit 1; }
