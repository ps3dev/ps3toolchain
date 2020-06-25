[![License](https://img.shields.io/github/license/ps3dev/ps3toolchain.svg)](./LICENSE)

  What does this do?
 ====================

  This program will automatically build and install a compiler and other
  tools used in the creation of homebrew software for the Sony PlayStation 3
  videogame system.

  How do I use it?
 ==================

 1) Set up your environment by installing the following software:

  autoconf, automake, bison, flex, gcc, libelf, make, makeinfo,
  ncurses, patch, python, subversion, wget, zlib, libtool, python,
  bzip2, gmp, pkg-config, g++, libssl-dev, clang

## Linux

  Specifically on debian-based systems, the following command line should
  be enough to install everything necessary:

```bash
  apt-get install autoconf automake bison flex gcc libelf-dev make \
    texinfo libncurses5-dev patch python subversion wget zlib1g-dev \
    libtool libtool-bin python-dev bzip2 libgmp3-dev pkg-config g++ libssl-dev clang
```

## macOS

  On macOS systems, if you have [Homebrew](http://brew.sh) package manager, the following command line should
  be enough to install everything necessary:

```bash
brew install autoconf automake openssl libelf ncurses zlib gmp wget pkg-config
```

 2) Add the following to your login script:
```bash
  export PS3DEV=/usr/local/ps3dev
  export PSL1GHT=$PS3DEV

  export PATH=$PATH:$PS3DEV/bin
  export PATH=$PATH:$PS3DEV/ppu/bin
  export PATH=$PATH:$PS3DEV/spu/bin
```

 3) Run the toolchain script:
```bash
  ./toolchain.sh
```
