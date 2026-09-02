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
  unpack_if_needed "../archives/${GDB}.tar.xz" "${GDB}"

  ## Patch the source code.
  apply_patch "../patches/${GDB}-PS3.patch" "${GDB}"

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
## pyenv ships Python 3.10; gdb 8.3.1 cannot build against that ABI.
## Host GCC 15/16 default to C23; bundled readline expects pre-C23
## unprototyped signal handlers (VOID_SIGHANDLER).
CFLAGS="${CFLAGS:-} -std=gnu17 -Wno-incompatible-pointer-types -Wno-int-conversion" \
CXXFLAGS="${CXXFLAGS:-} -std=gnu++17 -Wno-narrowing" \
../configure --prefix="$PS3DEV/spu" --target="spu" \
    --disable-nls \
    --disable-sim \
    --disable-werror \
    --with-python=no \
    --without-guile

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS
${MAKE:-make} libdir="$(pwd)/host-libs/lib" install
