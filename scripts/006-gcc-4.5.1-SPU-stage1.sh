#!/bin/sh
# gcc-4.5.1-SPU-stage1.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
wget --continue ftp://ftp.gnu.org/gnu/gcc/gcc-4.5.1/gcc-4.5.1.tar.bz2 || { exit 1; }
wget --continue ftp://ftp.gmplib.org/pub/gmp-5.0.1/gmp-5.0.1.tar.bz2 || { exit 1; }
wget --continue http://www.multiprecision.org/mpc/download/mpc-0.8.2.tar.gz || { exit 1; }
wget --continue http://www.mpfr.org/mpfr-2.4.2/mpfr-2.4.2.tar.bz2 || { exit 1; }

## Unpack the source code.
rm -Rf gcc-4.5.1 && tar xfvj gcc-4.5.1.tar.bz2 && cd gcc-4.5.1 || { exit 1; }

## Unpack the libraries.
tar xfvj ../gmp-5.0.1.tar.bz2 && ln -s gmp-5.0.1 gmp || { exit 1; }
tar xfvz ../mpc-0.8.2.tar.gz && ln -s mpc-0.8.2 mpc || { exit 1; }
tar xfvj ../mpfr-2.4.2.tar.bz2 && ln -s mprf-2.4.2 mpfr || { exit 1; }

## Create the build directory.
mkdir build-spu-stage1 && cd build-spu-stage1 || { exit 1; }

## Configure the build.
../configure --prefix="$PS3DEV/spu" --target="spu" --enable-languages="c,c++" --with-newlib || { exit 1; }

## Compile and install.
make clean && make -j 4 all-gcc && make install-gcc && make clean || { exit 1; }
