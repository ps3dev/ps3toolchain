#!/bin/sh -e
# gdb-SPU.sh by Naomi Peori (naomi@peori.ca)

GDB="gdb-8.3.1"

if [ ! -d ${GDB} ]; then

  ## Download the source code.
  if [ ! -f ${GDB}.tar.xz ]; then wget --continue https://ftp.gnu.org/gnu/gdb/${GDB}.tar.xz; fi

  ## Download an up-to-date config.guess and config.sub
  if [ ! -f config.guess ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.guess; fi
  if [ ! -f config.sub ]; then wget --continue https://git.savannah.gnu.org/cgit/config.git/plain/config.sub; fi

  ## Unpack the source code.
  tar xfvJ ${GDB}.tar.xz

  ## Patch the source code.
  cat ../patches/${GDB}-PS3.patch | patch -p1 -d ${GDB}

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

../configure --prefix="$PS3DEV/spu" --target="spu" \
    --disable-nls \
    --disable-sim \
    --disable-werror

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS && ${MAKE:-make} libdir=`pwd`/host-libs/lib install
