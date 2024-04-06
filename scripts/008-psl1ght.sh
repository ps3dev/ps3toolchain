#!/bin/sh -e
# psl1ght.sh by Naomi Peori (naomi@peori.ca)

PSL1GHT="PSL1GHT"

if [ ! -d ${PSL1GHT} ]; then

    ## Download the source code.
    wget --no-check-certificate https://github.com/ps3dev/$PSL1GHT/tarball/master -O $PSL1GHT.tar.gz

    ## Unpack the source code.
    rm -Rf $PSL1GHT && mkdir $PSL1GHT && tar --strip-components=1 --directory=$PSL1GHT -xvzf $PSL1GHT.tar.gz

fi

cd $PSL1GHT

## Compile and install.
${MAKE:-make} install-ctrl && ${MAKE:-make} && ${MAKE:-make} install