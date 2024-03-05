#!/bin/sh -e
# gcc-newlib-PPU.sh by Naomi Peori (naomi@peori.ca)

GCC="gcc-13.2.0"
NEWLIB="newlib-1.20.0"

if [ ! -d ${GCC} ]; then

  ## Download the source code.
  if [ ! -f ${GCC}.tar.xz ]; then wget --continue https://ftp.gnu.org/gnu/gcc/${GCC}/${GCC}.tar.xz; fi
  if [ ! -f ${NEWLIB}.tar.gz ]; then wget --continue https://sourceware.org/pub/newlib/${NEWLIB}.tar.gz; fi

  ## Unpack the source code.
  rm -Rf ${GCC} && tar xfvJ ${GCC}.tar.xz
  rm -Rf ${NEWLIB} && tar xfvz ${NEWLIB}.tar.gz

  ## Patch the source code.
  cat ../patches/${GCC}-PS3-PPU.patch | patch -p1 -d ${GCC}
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

if [ ! -d ${GCC}/build-ppu ]; then

  ## Create the build directory.
  mkdir ${GCC}/build-ppu

fi

## Enter the build directory.
cd ${GCC}/build-ppu

## Configure the build.


# Avoid breakage
CFLAGS="$CFLAGS -Werror=format-security"
CXXFLAGS="$CXXFLAGS -Werror=format-security"
../configure --prefix="$PS3DEV/ppu" --target="powerpc64-ps3-elf" \
		--with-cpu="cell" \
		--with-newlib \
		--with-system-zlib \
		--enable-languages="c,c++" \
		--enable-long-double-128 \
		--enable-lto \
		--enable-threads \
		--enable-newlib-multithread \
		--enable-newlib-hw-fp \
		--disable-dependency-tracking \
		--disable-libcc1 \
		--disable-multilib \
		--disable-nls \
		--disable-shared \
		--disable-win32-registry


# Check if the operating system is macOS
if [ "$(uname)" = "Darwin" ]; then
  alias sed='gsed'
fi
## TODO - Move it to patch file
sed -i 's/ifdef _GLIBCXX_HAVE_STRUCT_DIRENT_D_TYPE/if 0/' ../libstdc++-v3/src/filesystem/dir-common.h

## Compile and install.
PROCS="$(nproc --all 2>&1)" || ret=$?
if [ ! -z $ret ]; then PROCS=4; fi
${MAKE:-make} -j $PROCS all && ${MAKE:-make} install
