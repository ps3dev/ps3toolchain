#!/bin/sh
# symlinks-PPU.sh by Dan Peori (dan.peori@oopo.net)

## Enter the PPU directory.
cd $PS3DEV/ppu

## Create the directory symlinks.
ln -s powerpc64-ps3-lv2 ppu

## Enter the bin directory.
cd bin

## Create the bin symlinks.
ls powerpc64-ps3-lv2-* | cut -c19- | awk '{ print "ln -s powerpc64-ps3-lv2-"$0" ppu-"$0 }' | sh
