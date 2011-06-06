#!/bin/bash -e
# binutils-2.20.1-SPU.sh by Dan Peori (dan.peori@oopo.net)

if [ ! -d binutils-2.20.1 ]; then

  ## Download the source code.
  wget --continue ftp://ftp.gnu.org/gnu/binutils/binutils-2.20.1.tar.bz2

  ## Unpack the source code.
  tar xfvj binutils-2.20.1.tar.bz2

  ## Patch the source code.
  cat ../patches/binutils-2.20.1-PS3.patch | patch -p1 -d binutils-2.20.1

fi

if [ ! -d binutils-2.20.1/build-spu ]; then

  ## Create the build directory.
  mkdir binutils-2.20.1/build-spu

fi

## Enter the build directory.
cd binutils-2.20.1/build-spu

## Configure the build.
../configure --prefix="$PS3DEV/spu" --target="spu" \
    --disable-nls \
    --disable-shared \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-werror \
    --with-gcc \
    --with-gnu-as \
    --with-gnu-ld \


## Compile and install.
${MAKE:-make} -j 4 && ${MAKE:-make} install
