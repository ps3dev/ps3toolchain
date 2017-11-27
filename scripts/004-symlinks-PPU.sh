#!/bin/sh -e
# symlinks-PPU.sh by Naomi Peori (naomi@peori.ca)

## Enter the PPU directory.
cd ${PS3DEV}/ppu

## Create the directory symlinks.
if [ ! -d ppu -a ! -f ppu -a ! -h ppu -a -d powerpc64-ps3-elf ]; then
  ln -s powerpc64-ps3-elf ppu
fi

## Enter the bin directory.
cd ${PS3DEV}/ppu/bin

## Create the bin symlinks.
for i in `ls powerpc64-ps3-elf-* | cut -c19-`; do
  if [ ! -f ppu-${i} -a ! -h ppu-${i} -a -f powerpc64-ps3-elf-${i} ]; then
    ln -s powerpc64-ps3-elf-${i} ppu-${i}
  fi
done

