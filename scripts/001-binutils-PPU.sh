#!/bin/sh -e
#
# binutils-PPU.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

BINUTILS="binutils-2.22"

if [ ! -d ${BINUTILS} ]; then

  ## Download the source code.
  if [ ! -f ${BINUTILS}.tar.bz2 ]; then wget --continue https://ftp.gnu.org/gnu/binutils/${BINUTILS}.tar.bz2; fi

  ## Download an up-to-date config.guess and config.sub
  if [ ! -f config.guess ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.guess; fi
  if [ ! -f config.sub ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.sub; fi

  ## Unpack the source code.
  tar -I lbzip2 -xvf ${BINUTILS}.tar.bz2

  ## Patch the source code.
  cat ../patches/${BINUTILS}-PS3.patch | patch -p1 -d ${BINUTILS}

  ## Replace config.guess and config.sub
  cp config.guess config.sub ${BINUTILS}

fi

if [ ! -d ${BINUTILS}/build-ppu ]; then

  ## Create the build directory.
  mkdir ${BINUTILS}/build-ppu

fi

## Enter the build directory.
cd ${BINUTILS}/build-ppu

## Configure the build.
CFLAGS="-O3" CXXFLAGS="-O3" CFLAGS_FOR_TARGET="-O3" CXXFLAGS_FOR_TARGET="-O3" BOOT_CFLAGS="-O3" GOCFLAGS_FOR_TARGET="-O3" \
../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" --disable-nls --disable-shared --disable-debug --disable-dependency-tracking \
             --disable-werror --enable-64-bit-bfd --with-gcc --with-gnu-as --with-gnu-ld --with-cpu="cell" --with-tune="cell" \

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS --no-print-directory && ${MAKE:-make} libdir="host-libs/lib" install -j $PROCS --no-print-directory
