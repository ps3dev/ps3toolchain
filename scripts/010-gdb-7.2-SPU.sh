#!/bin/sh
# gdb-7.2-SPU.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
wget --continue ftp://ftp.gnu.org/gnu/gdb/gdb-7.2.tar.bz2 || { exit 1; }

## Unpack the source code.
rm -Rf gdb-7.2 && tar xfvj gdb-7.2.tar.bz2 && cd gdb-7.2 || { exit 1; }

## Patch the source code.
cat ../../patches/gdb-7.2-PS3.patch | patch -p1 || { exit ; }

## Create the build directory.
mkdir build-spu && cd build-spu || { exit 1; }

## Configure the build.
../configure --prefix="$PS3DEV/host/spu" --target="spu" \
    --disable-nls \
    --disable-sim \
    --disable-werror \
    || { exit 1; }

## Compile and install.
make -j 4 && make install || { exit 1; }
