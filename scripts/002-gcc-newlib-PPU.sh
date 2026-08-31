#!/usr/bin/env bash
set -eo pipefail
# gcc-newlib-PPU.sh by Naomi Peori (naomi@peori.ca)

GCC="gcc-13.2.0"
NEWLIB="newlib-1.20.0"
source ../utils/utils.sh

if [ ! -d ${GCC} ]; then

  ## Download the source code.
  ../download.sh ${GCC}.tar.xz
  ../download.sh ${NEWLIB}.tar.gz

  ## Unpack the source code.
  unpack_if_needed "../archives/${GCC}.tar.xz" "${GCC}"
  unpack_if_needed "../archives/${NEWLIB}.tar.gz" "${NEWLIB}"

  ## Patch the source code.
  apply_patch "../patches/${GCC}-PS3-PPU.patch" "${GCC}"
  apply_patch "../patches/${NEWLIB}-PS3.patch" "${NEWLIB}"

  ## Patch for macOS arm64
  if [[ $(uname -s) == 'Darwin' && $(uname -m) == 'arm64' ]]; then
    apply_patch "../patches/${GCC}-PS3-macos-arm64.patch" "${GCC}"
  fi

  ## Enter the source code directory.
  cd ${GCC}

  ## Create the newlib symlinks.
  ln -s ../${NEWLIB}/newlib newlib
  ln -s ../${NEWLIB}/libgloss libgloss

  ## Download the prerequisites.
  ./contrib/download_prerequisites

  ## Leave the source code directory.
  cd ..

fi

if [ ! -d ${GCC}/build-ppu ]; then

  ## Create the build directory.
  mkdir ${GCC}/build-ppu

fi

## Enter the build directory.
cd ${GCC}/build-ppu

## Configure the build.
CFLAGS="-Wno-int-conversion" CXXFLAGS="-Wno-int-conversion" ../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" \
    --disable-dependency-tracking \
    --disable-libcc1 \
    --disable-libstdcxx-pch \
    --disable-multilib \
    --disable-nls \
    --disable-shared \
    --disable-win32-registry \
    --enable-languages="c,c++" \
    --enable-long-double-128 \
    --enable-lto \
    --enable-threads \
    --with-cpu="cell" \
    --with-newlib \
    --enable-newlib-multithread \
    --enable-newlib-hw-fp \
    --with-system-zlib

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS all
${MAKE:-make} MULTIOSDIR=. install
