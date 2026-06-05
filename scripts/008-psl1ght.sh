#!/bin/sh -e
# psl1ght.sh by Naomi Peori (naomi@peori.ca)

## Unpack the source code.
rm -Rf psl1ght
mkdir psl1ght
echo "Unpacking psl1ght"
pv -pterb ../downloads/psl1ght-master.tar.gz | tar --strip-components=1 --directory=psl1ght -xzf -

## Create the build directory.
cd psl1ght

## Compile and install.
${MAKE:-make} install-ctrl && ${MAKE:-make} && ${MAKE:-make} install
