#!/bin/sh
# gdb-7.2-SPU.sh by Dan Peori (dan.peori@oopo.net)

if [ ! -d gdb-7.2 ]; then

  ## Download the source code.
  wget --continue ftp://ftp.gnu.org/gnu/gdb/gdb-7.2.tar.bz2 || { exit 1; }

  ## Unpack the source code.
  tar xfvj gdb-7.2.tar.bz2 || { exit 1; }

  ## Patch the source code.
  cat ../patches/gdb-7.2-PS3.patch | patch -p1 -d gdb-7.2 || { exit ; }

fi

if [ ! -d gdb-7.2/build-spu ]; then

  ## Create the build directory.
  mkdir gdb-7.2/build-spu || { exit 1; }

fi

## Enter the build directory.
cd gdb-7.2/build-spu || { exit 1; }

## Configure the build.
../configure --prefix="$PS3DEV/host/spu" --target="spu" \
    --disable-nls \
    --disable-sim \
    --disable-werror \
    || { exit 1; }

## Compile and install.
${MAKE:-make} -j 4 && ${MAKE:-make} install || { exit 1; }
