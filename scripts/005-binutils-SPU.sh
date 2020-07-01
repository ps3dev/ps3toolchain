#!/bin/sh -e
# binutils-SPU.sh by Naomi Peori (naomi@peori.ca)

# Set up our common variables and functions
. $(git rev-parse --show-toplevel)/scripts/.common.sh

update_submodule ${BINUTILS}

## Create the build directory.
mkdir -p ${BINUTILS}/build-spu

## Enter the build directory.
cd ${BINUTILS}/build-spu

## Configure the build.
${PS3DEV_SOURCES}/${BINUTILS}/configure \
    --prefix="${PS3DEV}/spu" \
    --target="spu" \
    --build="${BUILD_HOST}" \
    --disable-nls \
    --disable-shared \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-werror \
    --with-gcc \
    --with-gnu-as \
    --with-gnu-ld

## Compile and install.
${MAKE:-make} -j${PROC-} MAKEINFO=true && ${MAKE:-make} MAKEINFO=true libdir=host-libs/lib install
