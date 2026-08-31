#!/usr/bin/env bash
set -eo pipefail
# gcc-newlib-SPU.sh by Naomi Peori (naomi@peori.ca)

GCC="gcc-9.5.0"
NEWLIB="newlib-1.20.0"
source ../utils/utils.sh

if [ ! -d ${GCC} ]; then

  ## Download the source code.
  ../download.sh ${GCC}.tar.xz
  ../download.sh ${NEWLIB}.tar.gz

  ## Unpack the source code.
  unpack_if_needed "../archives/${GCC}.tar.xz" "${GCC}"
  unpack_if_needed "../archives/${NEWLIB}.tar.gz" "${NEWLIB}"

  ## Patch the source code. newlib is shared with the PPU step and
  ## must not be unpacked/patched a second time.
  apply_patch "../patches/${GCC}-PS3-SPU.patch" "${GCC}"
  apply_patch "../patches/${NEWLIB}-PS3.patch" "${NEWLIB}"

  ## libc++ 17+ (Xcode 16/26, Intel and Apple Silicon)
  if [[ $(uname -s) == 'Darwin' ]]; then
    apply_patch "../patches/${GCC}-PS3-macos.patch" "${GCC}"
  fi
  ## Apple Silicon host_hooks / native aarch64 detect
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

if [ ! -d ${GCC}/build-spu ]; then

  ## Create the build directory.
  mkdir ${GCC}/build-spu

fi

## newlib 1.20 config.sub rejects aarch64-apple-darwin (Apple Silicon).
refresh_config_scripts "${NEWLIB}" "${GCC}"

## Enter the build directory.
cd ${GCC}/build-spu

## Configure the build.
unset CFLAGS CXXFLAGS LDFLAGS
CFLAGS_FOR_TARGET="-Os -fpic -ffast-math -ftree-vectorize -funroll-loops -fschedule-insns -mdual-nops -mwarn-reloc" \
CFLAGS="-Wno-int-conversion" \
CXXFLAGS="-Wno-int-conversion" \
../configure --prefix="$PS3DEV/spu" --target="spu" \
		--enable-languages="c,c++" \
		--enable-lto \
		--enable-threads \
		--enable-newlib-multithread \
		--enable-newlib-hw-fp \
		--enable-obsolete \
		--disable-dependency-tracking \
		--disable-libcc1 \
		--disable-libssp \
		--disable-multilib \
		--disable-nls \
		--disable-shared \
		--disable-win32-registry \
		--with-system-zlib

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS all
${MAKE:-make} MULTIOSDIR=. install
