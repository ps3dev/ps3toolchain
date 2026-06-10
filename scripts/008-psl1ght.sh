#!/bin/sh -e
# psl1ght.sh by Naomi Peori (naomi@peori.ca)

## Download the source code.
wget --no-check-certificate https://github.com/ps3dev/PSL1GHT/tarball/master -O psl1ght.tar.gz

## Check if we want to skip this step
if [[ -n "$BUILD_PS3TOOLCHAIN_ONLY" ]]; then
    echo "PS3 Toolchain only set. Skipping..."
    exit 0
fi

## Unpack the source code.
rm -Rf psl1ght && mkdir psl1ght && tar --strip-components=1 --directory=psl1ght -xvzf psl1ght.tar.gz

## Create the build directory.
cd psl1ght

## Compile and install.
${MAKE:-make} install-ctrl && ${MAKE:-make} && ${MAKE:-make} install
