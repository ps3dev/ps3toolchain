#!/bin/bash -e
# newlib-1.19.0-SPU.sh by Dan Peori (dan.peori@oopo.net)

if [ ! -d newlib-1.19.0 ]; then

  ## Download the source code.
  wget --continue ftp://sources.redhat.com/pub/newlib/newlib-1.19.0.tar.gz

  ## Unpack the source code.
  tar xfvz newlib-1.19.0.tar.gz

  ## Patch the source code.
  cat ../patches/newlib-1.19.0-PS3.patch | patch -p1 -d newlib-1.19.0

fi

if [ ! -d newlib-1.19.0/build-spu ]; then

  ## Create the build directory.
  mkdir newlib-1.19.0/build-spu

fi

## Enter the build directory.
cd newlib-1.19.0/build-spu

## Configure the build.
../configure --prefix="$PS3DEV/spu" --target="spu" \
    --enable-newlib-multithread \
    --enable-newlib-hw-fp \
   

## Compile and install.
${MAKE:-make} -j 4 && ${MAKE:-make} install
