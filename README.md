# PS3 Toolchain [![License](https://img.shields.io/github/license/ps3dev/ps3toolchain.svg)](./LICENSE)

## What does this do?
- This program will automatically build and install a compiler and other
tools used in the creation of homebrew software for the Sony PlayStation 3
videogame system.

## How do I use it?

1. If you are using Linux or macOS, add this to the login script (`~/.bashrc` on Linux)

```bash
  export PS3DEV=/usr/local/ps3dev
  export PSL1GHT=$PS3DEV

  export PATH=$PATH:$PS3DEV/bin
  export PATH=$PATH:$PS3DEV/ppu/bin
  export PATH=$PATH:$PS3DEV/spu/bin
```

2. Update the shell for it with the new variables (on Linux the command is `source ~/.bashrc`)

### Install dependencies

#### Linux

- Specifically on `debian-based` systems, the following command line should
  be enough to install everything necessary:

```bash
  sudo apt install autoconf automake bison flex gcc libelf-dev make texinfo libncurses5-dev patch python subversion wget zlib1g-dev libtool libtool-bin python-dev bzip2 libgmp3-dev pkg-config g++ libssl-dev clang pigz
```

#### macOS

- On macOS systems, if you have [Homebrew](http://brew.sh) package manager, the following command line should be enough to install everything necessary:

```bash
brew install autoconf automake openssl libelf ncurses zlib gmp wget pkg-config pigz
```

### Install toolchain

3. Run the toolchain script:
 
```bash
./toolchain.sh
```

PS: If it doesn't work, run the version with sudo:
```bash
sudo ./toolchain-sudo.sh
```
