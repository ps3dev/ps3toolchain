#!/usr/bin/env bash
set -eo pipefail
# binutils-PPU.sh by Naomi Peori (naomi@peori.ca)

BINUTILS="binutils-2.22"
source ../utils/utils.sh

if [ ! -d ${BINUTILS} ]; then

  ## Download the source code.
  ../download.sh ${BINUTILS}.tar.bz2

  ## Fetch config.guess and config.sub, falling back to copies if Savannah is unavailable
  ../config/get-config-scripts.sh

  ## Unpack the source code.
  echo "Unpacking ${BINUTILS}"
  extract "../archives/${BINUTILS}.tar.bz2"

  ## Patch the source code.
  cat ../patches/${BINUTILS}-PS3.patch | patch -p1 -d ${BINUTILS}

  ## Replace config.guess and config.sub
  cp ../archives/config.guess ../archives/config.sub ${BINUTILS}

fi

if [ ! -d ${BINUTILS}/build-ppu ]; then

  ## Create the build directory.
  mkdir ${BINUTILS}/build-ppu

fi

## Enter the build directory.
cd ${BINUTILS}/build-ppu

## Configure the build.
../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" \
    --disable-nls \
    --disable-shared \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-werror \
    --enable-64-bit-bfd \
    --with-gcc \
    --with-gnu-as \
    --with-gnu-ld

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS
${MAKE:-make} libdir=host-libs/lib MULTIOSDIR=. install
