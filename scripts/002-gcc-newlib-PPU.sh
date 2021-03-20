#!/bin/sh -e
# gcc-newlib-PPU.sh by Naomi Peori (naomi@peori.ca)

GCC="gcc-7.2.0"
NEWLIB="newlib-1.20.0"

if [ ! -d ${GCC} ]; then

  ## Download the source code.
  if [ ! -f ${GCC}.tar.xz ]; then wget --continue https://ftp.gnu.org/gnu/gcc/${GCC}/${GCC}.tar.xz; fi
  if [ ! -f ${NEWLIB}.tar.gz ]; then wget --continue https://sourceware.org/pub/newlib/${NEWLIB}.tar.gz; fi

  ## Unpack the source code.
  rm -Rf ${GCC} && tar xfvJ ${GCC}.tar.xz
  rm -Rf ${NEWLIB} && tar xfvz ${NEWLIB}.tar.gz

  ## Patch the source code.
  patch -p1 -d ${GCC} < ../patches/${GCC}-PS3.patch
  patch -p1 -d ${NEWLIB} < ../patches/${NEWLIB}-PS3.patch

  ## Enter the source code directory.
  cd "${GCC}"

  ## Create the newlib symlinks.
  ln -s "../${NEWLIB}/newlib" newlib
  ln -s "../${NEWLIB}/libgloss" libgloss

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
../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" \
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
PROCESSORS="$(nproc --all 2>&1)"
[ -n "$PROCESSORS" ] && [ "$PROCESSORS" -gt 0 ] || PROCESSORS=4
${MAKE:-make} -j $PROCESSORS all && ${MAKE:-make} install
