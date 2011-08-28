#!/bin/sh -e
# binutils-2.21.1-PPU.sh by Dan Peori (dan.peori@oopo.net)

if [ ! -d binutils-2.21.1 ]; then

  ## Download the source code.
  wget --continue ftp://ftp.gnu.org/gnu/binutils/binutils-2.21.1a.tar.bz2

  ## Unpack the source code.
  tar xfvj binutils-2.21.1a.tar.bz2

  ## Patch the source code.
  cat ../patches/binutils-2.21.1-PS3.patch | patch -p1 -d binutils-2.21.1

fi

if [ ! -d binutils-2.21.1/build-ppu ]; then

  ## Create the build directory.
  mkdir binutils-2.21.1/build-ppu

fi

## Enter the build directory.
cd binutils-2.21.1/build-ppu

## Configure the build.
../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" \
    --disable-nls \
    --disable-shared \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-werror \
    --enable-64-bit-bfd \
    --with-gcc \
    --with-gnu-as \
    --with-gnu-ld \


## Compile and install.
${MAKE:-make} -j 4 && ${MAKE:-make} install
