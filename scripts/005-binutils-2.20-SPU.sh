#!/bin/sh
# binutils-2.20-SPU.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
wget --continue ftp://ftp.gnu.org/gnu/binutils/binutils-2.20.tar.bz2 || { exit 1; }

## Unpack the source code.
rm -Rf binutils-2.20 && tar xfvj binutils-2.20.tar.bz2 && cd binutils-2.20 || { exit 1; }

## Create the build directory.
mkdir build-spu && cd build-spu || { exit 1; }

## Configure the build.
../configure --prefix="$PS3DEV/spu" --target="spu" || { exit 1; }

## Compile and install.
make clean && make && make install && make clean || { exit 1; }
