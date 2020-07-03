#!/bin/sh -e
# binutils-PPU.sh by Naomi Peori (naomi@peori.ca)

# Set up our common variables and functions
. $(git rev-parse --show-toplevel)/scripts/.common.sh

update_submodule ${BINUTILS}

## Create the build directory.
mkdir -p ${BINUTILS}/build-ppu

## Enter the build directory.
cd ${BINUTILS}/build-ppu

## Configure the build.
${PS3DEV_SOURCES}/${BINUTILS}/configure \
    --prefix="${PS3DEV}/ppu" \
    --target="powerpc64-ps3-elf" \
    --build="${BUILD_HOST}" \
    --disable-nls \
    --disable-shared \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-werror \
    --enable-64-bit-bfd \
    --with-gcc \
    --with-gnu-as \
    --with-gnu-ld

## Compile and install.
${MAKE:-make} -j${PROC-} MAKEINFO=true && ${MAKE:-make} MAKEINFO=true libdir=host-libs/lib install
