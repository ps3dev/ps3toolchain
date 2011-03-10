#!/bin/sh
# psl1ght.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
#wget --no-check-certificate https://github.com/HACKERCHANNEL/PSL1GHT/tarball/master -O psl1ght.tar.gz || { exit 1; }
wget --no-check-certificate https://github.com/miigotu/PSL1GHT/tarball/mingw -O psl1ght.tar.gz || { exit 1; }

## Unpack the source code.
rm -Rf psl1ght && mkdir psl1ght && tar --strip-components=1 --directory=psl1ght -xvzf psl1ght.tar.gz || { exit 1; }

## Create the build directory.
cd psl1ght || { exit 1; }

## Compile and install.
make && make install || { exit 1; }
