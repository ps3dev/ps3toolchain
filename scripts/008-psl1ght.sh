#!/bin/sh -e
# psl1ght.sh by Naomi Peori (naomi@peori.ca)

PSL1GHT_DIR="PSL1GHT"

if [ ! -d ${PSL1GHT_DIR} ]; then

    ## Download the source code.
    wget --no-check-certificate https://github.com/ps3dev/$PSL1GHT_DIR/tarball/master -O $PSL1GHT_DIR.tar.gz

    ## Unpack the source code.
    rm -Rf $PSL1GHT_DIR && mkdir $PSL1GHT_DIR && tar --strip-components=1 --directory=$PSL1GHT_DIR -xvzf $PSL1GHT_DIR.tar.gz

fi

cd $PSL1GHT_DIR

## Compile and install.
${MAKE:-make} install-ctrl && ${MAKE:-make} && ${MAKE:-make} install