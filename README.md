# PS3 Toolchain [![License](https://img.shields.io/github/license/ps3dev/ps3toolchain.svg)](./LICENSE)

## What does this do?
- This program will automatically build and install a compiler and other
tools used in the creation of homebrew software for the Sony PlayStation 3
videogame system.

## How do I use it?

1. Set the `PS3DEV` and `PS1LIGHT` environment variables together with the executable/folder path (Linux folder `~/.bashrc` example)

```bash
 export PS3DEV=/usr/local/ps3dev
 export PSL1GHT=$PS3DEV

 export PATH=$PATH:$PS3DEV/bin
 export PATH=$PATH:$PS3DEV/ppu/bin
 export PATH=$PATH:$PS3DEV/spu/bin
```

2. Create the `$PS3DEV` folder (Linux example)

```bash
sudo mkdir $PS3DEV
```

3. Give yourself permission to write files to the `$PS3DEV` folder (Linux example)

```bash
sudo chown -R $USER:$USER $PS3DEV
```

4. Make sure the new variables are set in the shell (Linux command example `source ~/.bashrc`)

### Install dependencies

#### Linux

4.1. For Linux, these are the necessary packages:

```bash
autoconf automake bison flex gcc libelf-dev make texinfo libncurses5-dev patch python subversion wget zlib1g-dev libtool libtool-bin python-dev bzip2 libgmp3-dev pkg-config g++ libssl-dev clang
```

#### macOS

4.2. And for macOS, these are:

```bash
autoconf automake openssl libelf ncurses zlib gmp wget pkg-config
```

### Install toolchain

5. Run the toolchain script:

```bash
./toolchain.sh
```

PS: If it doesn't work, run the version with sudo:
```bash
sudo ./toolchain-sudo.sh
```
