#!/bin/sh -e
#
# gdb-SPU.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

GDB="gdb-7.5.1"

if [ ! -d ${GDB} ]; then

  ## Download the source code.
  if [ ! -f ${GDB}.tar.bz2 ]; then wget --continue https://ftp.gnu.org/gnu/gdb/${GDB}.tar.bz2; fi

  ## Download an up-to-date config.guess and config.sub
  if [ ! -f config.guess ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.guess; fi
  if [ ! -f config.sub ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.sub; fi

  ## Unpack the source code.
  tar xvjf ${GDB}.tar.bz2

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
CFLAGS="-g -Os" CXXFLAGS="-g -Os" CFLAGS_FOR_TARGET="-g -Os" CXXFLAGS_FOR_TARGET="-g -Os" GOCFLAGS_FOR_TARGET="-g -Os" BOOT_CFLAGS="-g -Os" \
../configure --prefix="$PS3DEV/spu" --target="spu" --disable-nls --disable-sim --disable-werror --with-cpu="cell" --with-tune="cell" \
             --with-endian="big" \

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j$PROCS --no-print-directory && ${MAKE:-make} libdir="host-libs/lib" install -j$PROCS --no-print-directory
