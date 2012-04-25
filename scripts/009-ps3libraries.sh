#!/bin/sh -e
# ps3libraries.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
wget --no-check-certificate https://github.com/ps3dev/ps3libraries/tarball/master -O ps3libraries.tar.gz

## Unpack the source code.
rm -Rf ps3libraries && mkdir ps3libraries && tar --strip-components=1 --directory=ps3libraries -xvzf ps3libraries.tar.gz && cd ps3libraries

## Compile and install.
./libraries.sh
