#!/bin/sh
# gdb-7.2-PPU.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
wget --continue ftp://ftp.gnu.org/gnu/gdb/gdb-7.2.tar.bz2 || { exit 1; }

## Unpack the source code.
rm -Rf gdb-7.2 && tar xfvj gdb-7.2.tar.bz2 && cd gdb-7.2 || { exit 1; }

## Patch the source code.
cat ../../patches/gdb-7.2-PS3.patch | patch -p1 || { exit ; }

## Create the build directory.
mkdir build-ppu && cd build-ppu || { exit 1; }

## Configure the build.
../configure --prefix="$PS3DEV/host/ppu" --target="ppu" \
    --disable-multilib \
    --disable-nls \
    --disable-sim \
    --disable-werror \
    || { exit 1; }

## Compile and install.
make -j 4 && make install || { exit 1; }
