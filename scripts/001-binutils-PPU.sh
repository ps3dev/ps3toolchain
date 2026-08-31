#!/usr/bin/env bash
set -eo pipefail
# binutils-PPU.sh by Naomi Peori (naomi@peori.ca)

BINUTILS="binutils-2.42"
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
  cat ../patches/${BINUTILS}-PS3-PPU.patch | patch -p1 -d ${BINUTILS}

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
unset LDFLAGS
../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" \
		--with-gcc \
		--with-gnu-as \
		--with-gnu-ld \
		--enable-64-bit-bfd \
		--enable-lto \
		--disable-nls \
		--disable-shared \
		--disable-debug \
		--disable-dependency-tracking \
		--disable-werror \
		--disable-gprofng \
		--disable-install-libiberty

## Compile and install.
## Do not override libdir: binutils 2.42 installs libdep.la into
## $libdir/bfd-plugins and libtool requires that path to be absolute.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS
${MAKE:-make} install
# Host libiberty can still land under prefix on some configure defaults.
rm -f "$PS3DEV/ppu/lib/libiberty.a" "$PS3DEV/ppu/lib64/libiberty.a"
