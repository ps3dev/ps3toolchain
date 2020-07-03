#!/bin/sh -e
# gdb-PPU.sh by Naomi Peori (naomi@peori.ca)

# Set up our common variables and functions
. $(git rev-parse --show-toplevel)/scripts/.common.sh

update_submodule ${GDB}

## Create the build directory.
mkdir -p ${GDB}/build-ppu

## Enter the build directory.
cd ${GDB}/build-ppu

## Configure the build.
${PS3DEV_SOURCES}/${GDB}/configure \
    --prefix="${PS3DEV}/ppu" \
    --target="powerpc64-ps3-elf" \
    --build="${BUILD_HOST}" \
    --disable-multilib \
    --disable-nls \
    --disable-sim \
    --disable-werror

## Compile and install.
${MAKE:-make} -j${PROC-} MAKEINFO=true && ${MAKE:-make} MAKEINFO=true libdir=host-libs/lib install
