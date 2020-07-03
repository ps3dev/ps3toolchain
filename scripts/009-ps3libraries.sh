#!/bin/sh -e
# ps3libraries.sh by Naomi Peori (naomi@peori.ca)

# Set up our common variables and functions
. $(git rev-parse --show-toplevel)/scripts/.common.sh

update_submodule ps3libraries

rm -Rf ps3libraries
cp -rf ${PS3DEV_SOURCES}/ps3libraries .
cd ps3libraries

## Compile and install.
./libraries.sh
