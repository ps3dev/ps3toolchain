#!/bin/sh -e
# binutils-SPU.sh by Naomi Peori (naomi@peori.ca)

BINUTILS="binutils-2.22"

if [ ! -d ${BINUTILS} ]; then

  ## Unpack the source code.
  echo "Unpacking ${BINUTILS}"
  pv -pterab ../downloads/${BINUTILS}.tar.bz2 | tar xjf -

  ## Patch the source code.
  cat ../patches/${BINUTILS}-PS3.patch | patch -p1 -d ${BINUTILS}

  ## Replace config.guess and config.sub
  cp "$(automake --print-libdir)"/config.guess "$(automake --print-libdir)"/config.sub ${BINUTILS}

fi

if [ ! -d ${BINUTILS}/build-spu ]; then

  ## Create the build directory.
  mkdir ${BINUTILS}/build-spu

fi

## Enter the build directory.
cd ${BINUTILS}/build-spu

## Configure the build.
../configure --prefix="$PS3DEV/spu" --target="spu" \
    --disable-nls \
    --disable-shared \
    --disable-debug \
    --disable-dependency-tracking \
    --disable-werror \
    --with-gcc \
    --with-gnu-as \
    --with-gnu-ld

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS && ${MAKE:-make} libdir=host-libs/lib install
