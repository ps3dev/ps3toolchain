#!/bin/sh -e
#
# binutils-SPU.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

BINUTILS="binutils-2.22"

if [ ! -d ${BINUTILS} ]; then

  ## Download the source code.
  if [ ! -f ${BINUTILS}.tar.gz ]; then wget --continue https://ftp.gnu.org/gnu/binutils/${BINUTILS}.tar.gz; fi

  ## Download an up-to-date config.guess and config.sub
  if [ ! -f config.guess ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.guess; fi
  if [ ! -f config.sub ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.sub; fi

  ## Unpack the source code.
  pigz -dc ${BINUTILS}.tar.gz | tar -xvf -

  ## Patch the source code.
  cat ../patches/${BINUTILS}-PS3.patch | patch -p1 -d ${BINUTILS}

  ## Replace config.guess and config.sub
  cp config.guess config.sub ${BINUTILS}

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
    --with-gnu-ld \
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
