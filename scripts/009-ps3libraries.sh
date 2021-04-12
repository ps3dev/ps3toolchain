#!/bin/sh -e
#
# ps3libraries.sh by Naomi Peori (naomi@peori.ca)
# Modified by luizfernandonb (luizfernando.nb@outlook.com)

PS3LIBRARIES='ps3libraries'

## Download the source code.
if [ ! -f ${PS3LIBRARIES}.tar.gz ]; then wget --no-check-certificate https://github.com/ps3dev/${PS3LIBRARIES}/tarball/master -O ${PS3LIBRARIES}.tar.gz; fi

## Unpack the source code.
rm -Rf ${PS3LIBRARIES} && mkdir ${PS3LIBRARIES} && tar xvf ${PS3LIBRARIES}.tar.gz --strip-components=1 --directory=${PS3LIBRARIES} && cd ${PS3LIBRARIES}

## Compile and install.
./libraries.sh
