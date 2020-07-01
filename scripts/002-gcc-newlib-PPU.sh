#!/bin/sh -e
# gcc-newlib-PPU.sh by Naomi Peori (naomi@peori.ca)

# Set up our common variables and functions
. $(git rev-parse --show-toplevel)/scripts/.common.sh

update_submodule ${GCC}
update_submodule ${NEWLIB}

cp -rf ${PS3DEV_SOURCES}/${GCC} ${GCC}

## Enter the source code directory.
cd ${GCC}

## Create the newlib symlinks.
[ -L newlib ] || ln -sf ${PS3DEV_SOURCES}/${NEWLIB}/newlib newlib
[ -L libgloss ] || ln -sf ${PS3DEV_SOURCES}/${NEWLIB}/libgloss libgloss

## Download the prerequisites.
./contrib/download_prerequisites

## Create and enter the build directory.
mkdir -p build-ppu && cd build-ppu

## Configure the build.
../configure \
    --prefix="${PS3DEV}/ppu" \
    --target="powerpc64-ps3-elf" \
    --disable-dependency-tracking \
    --disable-libcc1 \
    --disable-libstdcxx-pch \
    --disable-multilib \
    --disable-nls \
    --disable-shared \
    --disable-win32-registry \
    --enable-languages="c,c++" \
    --enable-long-double-128 \
    --enable-lto \
    --enable-threads \
    --with-cpu="cell" \
    --with-newlib \
    --with-system-zlib

## Compile and install.
${MAKE:-make} -j${PROC-} MAKEINFO=true && ${MAKE:-make} MAKEINFO=true install
