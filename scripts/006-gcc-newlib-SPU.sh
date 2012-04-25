#!/bin/sh -e
# gcc-newlib-SPU.sh by Dan Peori (dan.peori@oopo.net)

GCC="gcc-4.7.0"
NEWLIB="newlib-1.20.0"

if [ ! -d ${GCC} ]; then

  ## Download the source code.
  if [ ! -f ${GCC}.tar.bz2 ]; then wget --continue ftp://ftp.gnu.org/gnu/gcc/${GCC}/${GCC}.tar.bz2; fi
  if [ ! -f ${NEWLIB}.tar.gz ]; then wget --continue ftp://sources.redhat.com/pub/newlib/${NEWLIB}.tar.gz; fi

  ## Unpack the source code.
  rm -Rf ${GCC} && tar xfvj ${GCC}.tar.bz2
  rm -Rf ${NEWLIB} && tar xfvz ${NEWLIB}.tar.gz

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
../configure --prefix="$PS3DEV/spu" --target="spu" \
    --disable-dependency-tracking \
    --disable-libssp \
    --disable-multilib \
    --disable-nls \
    --disable-shared \
    --disable-win32-registry \
    --enable-languages="c,c++" \
    --enable-lto \
    --enable-threads \
    --with-newlib

## Compile and install.
${MAKE:-make} -j 4 all && ${MAKE:-make} install
