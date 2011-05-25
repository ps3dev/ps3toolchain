#!/bin/sh
# symlinks-PPU.sh by Dan Peori (dan.peori@oopo.net)

## Enter the PPU bin directory.
cd $PS3DEV/ppu/bin

## Create the symlinks.
ls powerpc64-ps3-lv2-* | cut -c19- | awk '{ print "ln -s powerpc64-ps3-lv2-"$0" ppu-"$0 }' | sh
