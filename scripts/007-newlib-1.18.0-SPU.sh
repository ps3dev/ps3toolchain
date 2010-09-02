#!/bin/sh
# newlib-1.18.0-SPU.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
wget --continue ftp://sources.redhat.com/pub/newlib/newlib-1.18.0.tar.gz || { exit 1; }

## Unpack the source code.
rm -Rf newlib-1.18.0 && tar xfvz newlib-1.18.0.tar.gz && cd newlib-1.18.0 || { exit 1; }

## Create the build directory.
mkdir build-spu && cd build-spu || { exit 1; }

## Configure the build.
../configure --prefix="$PS3DEV/spu" --target="spu" || { exit 1; }

## Compile and install.
make clean && make && make install && make clean || { exit 1; }
