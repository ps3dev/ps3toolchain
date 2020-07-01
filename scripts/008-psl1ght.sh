#!/bin/sh -e
# psl1ght.sh by Naomi Peori (naomi@peori.ca)

# Set up our common variables and functions
. $(git rev-parse --show-toplevel)/scripts/.common.sh

update_submodule PSL1GHT

rm -Rf PSL1GHT
cp -rf ${PS3DEV_SOURCES}/PSL1GHT .
cd PSL1GHT

## Compile and install.
${MAKE:-make} MAKEINFO=true install-ctrl && ${MAKE:-make} -j${PROC-} MAKEINFO=true && ${MAKE:-make} MAKEINFO=true install
