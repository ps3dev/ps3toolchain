#!/bin/sh -e
# ps3libraries.sh by Naomi Peori (naomi@peori.ca)

CACHE_DIR="ps3libraries-temp-download-cache"
DOWNLOADS_DIR="ps3libraries/downloads"

## Preserve download cache
if [ -d "$DOWNLOADS_DIR" ]; then
    cp -r "$DOWNLOADS_DIR" "$CACHE_DIR"
fi

## Unpack the source code.
rm -Rf ps3libraries
mkdir ps3libraries
echo "Unpacking ps3libraries"
pv -pterb ../downloads/ps3libraries-master.tar.gz | tar --strip-components=1 --directory=ps3libraries -xzf -

## Restore download cache
if [ -d "$CACHE_DIR" ]; then
    mkdir -p "$DOWNLOADS_DIR"
    cp -r "$CACHE_DIR/." "$DOWNLOADS_DIR/"
fi

cd ps3libraries

## Compile and install.
./libraries.sh
