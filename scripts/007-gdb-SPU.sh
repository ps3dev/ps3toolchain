#!/bin/sh -e
# gdb-SPU.sh by Naomi Peori (naomi@peori.ca)

# Set up our common variables and functions
. $(git rev-parse --show-toplevel)/scripts/.common.sh

update_submodule ${GDB}

## Create the build directory.
mkdir -p ${GDB}/build-spu

## Enter the build directory.
cd ${GDB}/build-spu

## Configure the build.
${PS3DEV_SOURCES}/${GDB}/configure \
    --prefix="${PS3DEV}/spu" \
    --target="spu" \
    --build="${BUILD_HOST}" \
    --disable-nls \
    --disable-sim \
    --disable-werror

## Compile and install.
${MAKE:-make} -j${PROC-} MAKEINFO=true && ${MAKE:-make} MAKEINFO=true libdir=host-libs/lib install
