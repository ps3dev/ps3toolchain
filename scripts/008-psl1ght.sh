#!/usr/bin/env bash
set -eo pipefail
# psl1ght.sh by Naomi Peori (naomi@peori.ca)

## Check if we want to skip this step
if [ -n "$BUILD_PS3TOOLCHAIN_ONLY" ]; then
    echo "PS3 Toolchain only set. Skipping..."
    exit 0
fi

source ../utils/utils.sh

## Download the source code.
../download.sh psl1ght.tar.gz

## Unpack the source code.
rm -Rf psl1ght
mkdir psl1ght
echo "Unpacking psl1ght"
extract ../archives/psl1ght.tar.gz --strip-components=1 --directory=psl1ght
cd psl1ght

## Compile and install.
${MAKE:-make} install-ctrl && ${MAKE:-make} && ${MAKE:-make} install
