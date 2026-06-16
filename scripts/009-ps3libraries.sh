#!/usr/bin/env bash
set -eo pipefail
# ps3libraries.sh by Naomi Peori (naomi@peori.ca)

## Check if we want to skip this step
if [ -n "$BUILD_PS3TOOLCHAIN_ONLY" ]; then
    echo "PS3 Toolchain only set. Skipping..."
    exit 0
fi

source ../utils/utils.sh

## Download the source code.
../download.sh ps3libraries.tar.gz

## Unpack the source code.
rm -Rf ps3libraries
mkdir ps3libraries
echo "Unpacking ps3libraries"
extract ../archives/ps3libraries.tar.gz --strip-components=1 --directory=ps3libraries
cd ps3libraries

## Compile and install.
./libraries.sh
