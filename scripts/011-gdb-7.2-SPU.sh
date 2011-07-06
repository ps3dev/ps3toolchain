#!/bin/sh -e
# gdb-7.2-SPU.sh by Dan Peori (dan.peori@oopo.net)

if [ ! -d gdb-7.2 ]; then

  ## Download the source code.
  wget --continue ftp://ftp.gnu.org/gnu/gdb/gdb-7.2.tar.bz2

  ## Unpack the source code.
  tar xfvj gdb-7.2.tar.bz2

fi

if [ ! -d gdb-7.2/build-spu ]; then

  ## Create the build directory.
  mkdir gdb-7.2/build-spu

fi

## Enter the build directory.
cd gdb-7.2/build-spu

## Configure the build.
../configure --prefix="$PS3DEV/spu" --target="spu" \
    --disable-nls \
    --disable-sim \
    --disable-werror \


## Compile and install.
${MAKE:-make} -j 4 && ${MAKE:-make} install
