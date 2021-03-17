#!/bin/sh -e
#
# gdb-SPU.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

GDB="gdb-10.1"

if [ ! -d ${GDB} ]; then

  ## Download the source code.
  if [ ! -f ${GDB}.tar.gz ]; then wget --continue https://ftp.gnu.org/gnu/gdb/${GDB}.tar.gz; fi

  ## Download an up-to-date config.guess and config.sub
  if [ ! -f config.guess ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.guess; fi
  if [ ! -f config.sub ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.sub; fi

  ## Unpack the source code.
  pigz -dc ${GDB}.tar.gz | tar -xvf -

  ## Replace config.guess and config.sub
  cp config.guess config.sub ${GDB}

fi

if [ ! -d ${GDB}/build-spu ]; then

  ## Create the build directory.
  mkdir ${GDB}/build-spu

fi

## Enter the build directory.
cd ${GDB}/build-spu

## Configure the build.
../configure --prefix="$PS3DEV/spu" --target="spu" \
    --disable-nls \
    --disable-sim \
    --disable-werror \
    CFLAGS="-O3" \
    CXXFLAGS="-g -O3" \
    CCFLAGS_FOR_TARGET="-g -O3" \
    CXXFLAGS_FOR_TARGET="-g -O3" \
    GOCFLAGS_FOR_TARGET="-O3 -g" \
    BOOT_CFLAGS="-g -O3" \

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS && ${MAKE:-make} libdir=host-libs/lib install
