#!/bin/sh -e
#
# psl1ght.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

PS3DEV_PSL1GHT='psl1ght'

## Download the source code.
if [ ! -f ${PS3DEV_PSL1GHT}.tar.gz ]; then wget --no-check-certificate https://github.com/ps3dev/${PS3DEV_PSL1GHT}/tarball/master -O ${PS3DEV_PSL1GHT}.tar.gz; fi

## Unpack the source code.
rm -Rf ${PS3DEV_PSL1GHT} && mkdir ${PS3DEV_PSL1GHT} && tar xvf ${PS3DEV_PSL1GHT}.tar.gz --strip-components=1 --directory=${PS3DEV_PSL1GHT}

## Create the build directory.
cd ${PS3DEV_PSL1GHT}

## Compile and install.
${MAKE:-make} install-ctrl -j$(nproc) --no-print-directory && ${MAKE:-make} -j$(nproc) --no-print-directory && ${MAKE:-make} install -j$(nproc) --no-print-directory
