#!/bin/sh -e
# psl1ght.sh by Naomi Peori (naomi@peori.ca)

## Download the source code.
wget --no-check-certificate https://github.com/ps3dev/PSL1GHT/tarball/master -O psl1ght.tar.gz

## Unpack the source code.
rm -Rf psl1ght && mkdir psl1ght && tar --strip-components=1 --directory=psl1ght -xvzf psl1ght.tar.gz

# Convert file to unix line endings
dos2unix psl1ght/tools/fself/Makefile

# Patch for building on Mac os X
cat ../patches/psl1ght-PS3.patch | patch -p2 -d psl1ght

## Enter the build directory.
cd psl1ght

## Compile and install.
${MAKE:-make} install-ctrl && ${MAKE:-make} && ${MAKE:-make} install
