#!/bin/bash -e
# gcc-4.5.2-PPU-stage2.sh by Dan Peori (dan.peori@oopo.net)

if [ ! -d gcc-4.5.2 ]; then

  ## Download the source code.
  wget --continue ftp://ftp.gnu.org/gnu/gcc/gcc-4.5.2/gcc-4.5.2.tar.bz2

  ## Downlow the library source code.
  wget --continue ftp://ftp.gmplib.org/pub/gmp-5.0.1/gmp-5.0.1.tar.bz2
  wget --continue http://www.multiprecision.org/mpc/download/mpc-0.8.2.tar.gz
  wget --continue http://www.mpfr.org/mpfr-2.4.2/mpfr-2.4.2.tar.bz2

  ## Unpack the source code.
  rm -Rf gcc-4.5.2 && tar xfvj gcc-4.5.2.tar.bz2

  ## Patch the source code.
  cat ../patches/gcc-4.5.2-PS3.patch | patch -p1 -d gcc-4.5.2

  ## Enter the source code directory.
  cd gcc-4.5.2

  ## Unpack the library source code.
  tar xfvj ../gmp-5.0.1.tar.bz2 && ln -s gmp-5.0.1 gmp
  tar xfvz ../mpc-0.8.2.tar.gz && ln -s mpc-0.8.2 mpc
  tar xfvj ../mpfr-2.4.2.tar.bz2 && ln -s mpfr-2.4.2 mpfr

  ## Leave the source code directory.
  cd ..

fi

if [ ! -d gcc-4.5.2/build-ppu ]; then

  ## Create the build directory.
  mkdir gcc-4.5.2/build-ppu

fi

## Enter the build directory.
cd gcc-4.5.2/build-ppu

## Configure the build.
../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" \
    --disable-dependency-tracking \
    --disable-libstdcxx-pch \
    --disable-multilib \
    --disable-nls \
    --disable-shared \
    --disable-win32-registry \
    --enable-languages="c,c++,objc,obj-c++" \
    --enable-long-double-128 \
    --enable-lto \
    --enable-threads \
    --with-cpu="cell" \
    --with-newlib \
   

## Compile and install.
${MAKE:-make} -j 4 all && ${MAKE:-make} install
