#!/usr/bin/env bash
set -eo pipefail
# gdb-SPU.sh by Naomi Peori (naomi@peori.ca)

GDB="gdb-8.3.1"
source ../utils/utils.sh

if [ ! -d ${GDB} ]; then

  ## Download the source code.
  ../download.sh ${GDB}.tar.xz

  ## Fetch config.guess and config.sub, falling back to copies if Savannah is unavailable
  ../config/get-config-scripts.sh

  ## Unpack the source code.
  echo "Unpacking ${GDB}"
  extract "../archives/${GDB}.tar.xz"

  ## Patch the source code.
  cat ../patches/${GDB}-PS3.patch | patch -p1 -d ${GDB}

  ## Replace config.guess and config.sub
  cp ../archives/config.guess ../archives/config.sub ${GDB}

fi

if [ ! -d ${GDB}/build-spu ]; then

  ## Create the build directory.
  mkdir ${GDB}/build-spu

fi

## Enter the build directory.
cd ${GDB}/build-spu

## Configure the build.
CFLAGS="${CFLAGS:-} -std=gnu17 -Wno-incompatible-pointer-types -Wno-int-conversion -Wno-implicit-function-declaration" \
../configure --prefix="$PS3DEV/spu" --target="spu" \
    --disable-nls \
    --disable-sim \
    --disable-werror

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS && ${MAKE:-make} libdir=host-libs/lib install
