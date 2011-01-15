#!/bin/sh
# binutils-2.20.1-SPU.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
wget --continue ftp://ftp.gnu.org/gnu/binutils/binutils-2.20.1.tar.bz2 || { exit 1; }

## Unpack the source code.
rm -Rf binutils-2.20.1 && tar xfvj binutils-2.20.1.tar.bz2 && cd binutils-2.20.1 || { exit 1; }

## Patch the source code.
cat ../../patches/binutils-2.20.1-PS3.patch | patch -p1 || { exit ; }

## Create the build directory.
mkdir build-spu && cd build-spu || { exit 1; }

## Configure the build.
../configure --prefix="$PS3DEV/host/spu" --target="spu" \
    --disable-nls \
    --disable-shared \
    --disable-debug \
    --disable-dependency-tracking \
    --with-gcc \
    --with-gnu-as \
    --with-gnu-ld \
    || { exit 1; }

## Compile and install.
make -j 4 && make install || { exit 1; }
