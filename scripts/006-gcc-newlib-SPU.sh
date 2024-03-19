#!/bin/sh -e
# gcc-newlib-SPU.sh by Naomi Peori (naomi@peori.ca)

GCC="gcc-9.5.0"
NEWLIB="newlib-1.20.0"

if [ ! -d ${GCC} ]; then

  ## Download the source code.
  if [ ! -f ${GCC}.tar.xz ]; then wget --continue https://ftp.gnu.org/gnu/gcc/${GCC}/${GCC}.tar.xz; fi
  if [ ! -f ${NEWLIB}.tar.gz ]; then wget --continue https://sourceware.org/pub/newlib/${NEWLIB}.tar.gz; fi

  ## Unpack the source code.
  rm -Rf ${GCC} && tar xfvJ ${GCC}.tar.xz
  rm -Rf ${NEWLIB} && tar xfvz ${NEWLIB}.tar.gz

  ## Patch the source code.
  cat ../patches/${GCC}-PS3-SPU.patch | patch -p1 -d ${GCC}
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
unset CFLAGS CXXFLAGS LDFLAGS
CFLAGS_FOR_TARGET="-Os -fpic -ffast-math -ftree-vectorize -funroll-loops -fschedule-insns -mdual-nops -mwarn-reloc" \
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
		--disable-win32-registry

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS all && ${MAKE:-make} install
