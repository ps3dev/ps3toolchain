#!/bin/sh
# gcc-4.5.2-SPU-stage2.sh by Dan Peori (dan.peori@oopo.net)

## Download the source code.
wget --continue ftp://ftp.gnu.org/gnu/gcc/gcc-4.5.2/gcc-4.5.2.tar.bz2 || { exit 1; }

## Download the library source code.
wget --continue ftp://ftp.gmplib.org/pub/gmp-5.0.1/gmp-5.0.1.tar.bz2 || { exit 1; }
wget --continue http://www.multiprecision.org/mpc/download/mpc-0.8.2.tar.gz || { exit 1; }
wget --continue http://www.mpfr.org/mpfr-2.4.2/mpfr-2.4.2.tar.bz2 || { exit 1; }

## Unpack the source code.
rm -Rf gcc-4.5.2 && tar xfvj gcc-4.5.2.tar.bz2 && cd gcc-4.5.2 || { exit 1; }

## Patch the source code.
cat ../../patches/gcc-4.5.2-PS3.patch | patch -p1 || { exit 1; }

## Unpack the library source code.
tar xfvj ../gmp-5.0.1.tar.bz2 && ln -s gmp-5.0.1 gmp || { exit 1; }
tar xfvz ../mpc-0.8.2.tar.gz && ln -s mpc-0.8.2 mpc || { exit 1; }
tar xfvj ../mpfr-2.4.2.tar.bz2 && ln -s mpfr-2.4.2 mpfr || { exit 1; }

## Create the build directory.
mkdir build-spu-stage2 && cd build-spu-stage2 || { exit 1; }

## Configure the build.
../configure --prefix="$PS3DEV/host/spu" --target="spu" \
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
    || { exit 1; }

## Compile and install.
make -j 4 all && make install || { exit 1; }
