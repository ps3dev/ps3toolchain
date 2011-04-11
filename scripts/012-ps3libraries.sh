#!/bin/sh
# ps3libraries.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
wget --no-check-certificate https://github.com/ooPo/ps3libraries/tarball/master -O ps3libraries.tar.gz || { exit 1; }

## Unpack the source code.
rm -Rf ps3libraries && mkdir ps3libraries && tar --strip-components=1 --directory=ps3libraries -xvzf ps3libraries.tar.gz && cd ps3libraries || { exit 1; }

## Compile and install.
./libraries.sh || { exit 1; }
