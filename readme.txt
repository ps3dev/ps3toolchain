
 ====================
  What does this do?
 ====================

  This program will automatically build and install a compiler and other
  tools used in the creation of homebrew software for the Sony Playstation 3
  videogame system.

 ==================
  How do I use it?
 ==================

 1) Set up your environment by installing the following software:

  autoconf, automake, bison, flex, gcc, libelf, make, makeinfo,
  ncurses, patch, python, subversion, wget, zlib

 2) Add the following to your login script:

  export PS3DEV=/usr/local/ps3dev
  export PATH=$PATH:$PS3DEV/bin
  export PATH=$PATH:$PS3DEV/ppu/bin
  export PATH=$PATH:$PS3DEV/spu/bin

  export DEVKITPRO=$PS3DEV
  export DEVKITPS3=$PS3DEV
  export PSL1GHT=$PS3DEV/libpsl1ght

 3) Run the toolchain script:

  ./toolchain.sh
