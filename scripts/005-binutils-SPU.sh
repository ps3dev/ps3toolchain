#!/usr/bin/env bash
set -eo pipefail
# binutils-SPU.sh by Naomi Peori (naomi@peori.ca)

BINUTILS="binutils-2.22"
source ../utils/utils.sh

if [ ! -d ${BINUTILS} ]; then

  ## Download the source code.
  ../download.sh ${BINUTILS}.tar.bz2

  ## Fetch config.guess and config.sub, falling back to copies if Savannah is unavailable
  ../config/get-config-scripts.sh

  ## Unpack the source code.
  unpack_if_needed "../archives/${BINUTILS}.tar.bz2" "${BINUTILS}"

  ## Patch the source code.
  apply_patch "../patches/${BINUTILS}-PS3-SPU.patch" "${BINUTILS}"

  ## Replace config.guess and config.sub
  cp ../archives/config.guess ../archives/config.sub ${BINUTILS}

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
		--enable-lto \
		--with-system-zlib

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS
${MAKE:-make} libdir=host-libs/lib MULTIOSDIR=. install
