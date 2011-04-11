#!/bin/sh
# newlib-1.19.0-PPU.sh by Dan Peori (dan.peori@oopo.net)

if [ ! -d newlib-1.19.0 ]; then

  ## Download the source code.
  wget --continue ftp://sources.redhat.com/pub/newlib/newlib-1.19.0.tar.gz || { exit 1; }

  ## Unpack the source code.
  tar xfvz newlib-1.19.0.tar.gz || { exit 1; }

  ## Patch the source code.
  cat ../patches/newlib-1.19.0-PS3.patch | patch -p1 -d newlib-1.19.0 || { exit 1; }

fi

if [ ! -d newlib-1.19.0/build-ppu ]; then

  ## Create the build directory.
  mkdir newlib-1.19.0/build-ppu || { exit 1; }

fi

## Enter the build directory.
cd newlib-1.19.0/build-ppu || { exit 1; }

## Configure the build.
../configure --prefix="$PS3DEV/ppu" --target="ppu" \
    --enable-newlib-multithread \
    --enable-newlib-hw-fp \
    || { exit 1; }

## Compile and install.
${MAKE:-make} -j 4 && ${MAKE:-make} install || { exit 1; }
