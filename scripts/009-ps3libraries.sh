#!/bin/sh -e
#
# ps3libraries.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

## Download the source code.
wget --no-check-certificate https://github.com/ps3dev/ps3libraries/tarball/master -O ps3libraries.tar.gz

## Unpack the source code.
rm -Rf ps3libraries && mkdir ps3libraries && pigz -dc ps3libraries.tar.gz | tar --strip-components=1 --directory=ps3libraries -xvf \
											 ps3libraries.tar.gz && cd ps3libraries

## Compile and install.
./libraries.sh
