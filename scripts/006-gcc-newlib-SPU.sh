#!/bin/sh -e
# gcc-newlib-SPU.sh by Naomi Peori (naomi@peori.ca)

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
mkdir -p build-spu && cd build-spu

## Configure the build.
../configure \
    --prefix="${PS3DEV}/spu" \
    --target="spu" \
    --disable-dependency-tracking \
    --disable-libcc1 \
    --disable-libssp \
    --disable-multilib \
    --disable-nls \
    --disable-shared \
    --disable-win32-registry \
    --enable-languages="c,c++" \
    --enable-lto \
    --enable-threads \
    --with-newlib

## Compile and install.
${MAKE:-make} -j${PROC-} MAKEINFO=true && ${MAKE:-make} MAKEINFO=true install
