#!/bin/sh -e
# ps3libraries.sh by Naomi Peori (naomi@peori.ca)

## Check if we want to skip this step
if [ -n "$BUILD_PS3TOOLCHAIN_ONLY" ]; then
    echo "PS3 Toolchain only set. Skipping..."
    exit 0
fi

## Download the source code.
wget --no-check-certificate https://github.com/ps3dev/ps3libraries/tarball/master -O ps3libraries.tar.gz

## Unpack the source code.
rm -Rf ps3libraries && mkdir ps3libraries && tar --strip-components=1 --directory=ps3libraries -xvzf ps3libraries.tar.gz && cd ps3libraries

## Compile and install.
./libraries.sh
