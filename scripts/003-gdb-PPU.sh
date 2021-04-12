#!/bin/sh -e
#
# gdb-PPU.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

GDB="gdb-7.5.1"

if [ ! -d ${GDB} ]; then

  ## Download the source code.
  if [ ! -f ${GDB}.tar.xz ]; then wget --continue https://ftp.gnu.org/gnu/gdb/${GDB}.tar.xz; fi

  ## Download an up-to-date config.guess and config.sub
  if [ ! -f config.guess ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.guess; fi
  if [ ! -f config.sub ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.sub; fi

  ## Unpack the source code.
  tar xvJf ${GDB}.tar.xz

  ## Replace config.guess and config.sub
  cp config.guess config.sub ${GDB}

fi

if [ ! -d ${GDB}/build-ppu ]; then

  ## Create the build directory.
  mkdir ${GDB}/build-ppu

fi

## Enter the build directory.
cd ${GDB}/build-ppu

## Configure the build.
CFLAGS="-g -O3" CXXFLAGS="-g -O3" CFLAGS_FOR_TARGET="-g -O3" CXXFLAGS_FOR_TARGET="-g -O3" BOOT_CFLAGS="-g -O3" GOCFLAGS_FOR_TARGET="-g -O3" \
../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" --disable-multilib --disable-nls --disable-sim --disable-werror -with-cpu="cell" \
             --with-tune="cell" \

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j$PROCS --no-print-directory && ${MAKE:-make} libdir="host-libs/lib" install -j$PROCS --no-print-directory
