#!/bin/sh -e
#
# gcc-newlib-SPU.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

GCC="gcc-7.2.0"
NEWLIB="newlib-1.20.0"

if [ ! -d ${GCC} ]; then

  ## Download the source code.
  if [ ! -f ${GCC}.tar.xz ]; then wget --continue https://ftp.gnu.org/gnu/gcc/${GCC}/${GCC}.tar.xz; fi
  if [ ! -f ${NEWLIB}.tar.gz ]; then wget --continue https://sourceware.org/pub/newlib/${NEWLIB}.tar.gz; fi

  ## Unpack the source code.
  rm -Rf ${GCC} && tar xvJf ${GCC}.tar.xz
  rm -Rf ${NEWLIB} && tar xvf ${NEWLIB}.tar.gz

  ## Patch the source code.
  cat ../patches/${GCC}-PS3.patch | patch -p1 -d ${GCC}
  cat ../patches/${NEWLIB}-PS3.patch | patch -p1 -d ${NEWLIB}

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

## Enter the build directory.
cd ${GCC}/build-spu

## Configure the build.
CFLAGS="-g -Os" CXXFLAGS="-g -Os" CFLAGS_FOR_TARGET="-g -Os" CXXFLAGS_FOR_TARGET="-g -Os" GOCFLAGS_FOR_TARGET="-g -Os" BOOT_CFLAGS="-g -Os" \
../configure --prefix="$PS3DEV/spu" --target="spu" --disable-dependency-tracking --disable-libcc1 --disable-libssp --disable-multilib \
             --disable-nls --disable-shared --disable-win32-registry --enable-languages="c,c++" --enable-lto --enable-threads --with-newlib \
             --enable-newlib-multithread --enable-newlib-hw-fp --with-tune="cell" --with-endian="big" \

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} all -j$PROCS --no-print-directory && ${MAKE:-make} install -j$PROCS --no-print-directory
