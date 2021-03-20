#!/bin/sh -e
# gdb-PPU.sh by Naomi Peori (naomi@peori.ca)

GDB="gdb-7.5.1"

if [ ! -d ${GDB} ]; then

  ## Download the source code.
  if [ ! -f ${GDB}.tar.bz2 ]; then wget --continue https://ftp.gnu.org/gnu/gdb/${GDB}.tar.bz2; fi

  ## Download an up-to-date config.guess and config.sub
  if [ ! -f config.guess ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.guess; fi
  if [ ! -f config.sub ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.sub; fi

  ## Unpack the source code.
  tar xfvj ${GDB}.tar.bz2

  ## Patch the source code.
  patch -p1 -d ${GDB} < ../patches/${GDB}-PS3.patch

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
../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" \
    --disable-multilib \
    --disable-nls \
    --disable-sim \
    --disable-werror

## Compile and install.
PROCESSORS="$(nproc --all 2>&1)"
[ -n "$PROCESSORS" ] && [ "$PROCESSORS" -gt 0 ] || PROCESSORS=4
${MAKE:-make} -j $PROCESSORS && ${MAKE:-make} libdir=host-libs/lib install
