#!/bin/sh -e
# gcc-4.6.1-SPU-stage2.sh by Dan Peori (dan.peori@oopo.net)

if [ ! -d gcc-4.6.1 ]; then

  ## Download the source code.
  wget --continue ftp://ftp.gnu.org/gnu/gcc/gcc-4.6.1/gcc-4.6.1.tar.bz2

  ## Unpack the source code.
  rm -Rf gcc-4.6.1 && tar xfvj gcc-4.6.1.tar.bz2

  ## Patch the source code.
  cat ../patches/gcc-4.6.1-PS3.patch | patch -p1 -d gcc-4.6.1

  ## Enter the source code directory.
  cd gcc-4.6.1

  ## Download the prerequisites.
  ./contrib/download_prerequisites

  ## Leave the source code directory.
  cd ..

fi

if [ ! -d gcc-4.6.1/build-spu ]; then

  ## Create the build directory.
  mkdir gcc-4.6.1/build-spu

fi

## Enter the build directory.
cd gcc-4.6.1/build-spu

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
    --with-newlib \


## Compile and install.
${MAKE:-make} -j 4 all && ${MAKE:-make} install
