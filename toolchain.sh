#!/bin/sh
# toolchain.sh by Dan Peori (dan.peori@oopo.net)

## Enter the ps3toolchain directory.
cd "`dirname $0`" || { echo "ERROR: Could not enter the ps3toolchain directory."; exit 1; }

## Create the build directory.
mkdir -p build && cd build || { echo "ERROR: Could not create the build directory."; exit 1; }

## Use gmake if available
which gmake 1>/dev/null 2>&1 && export MAKE=gmake

## Fetch the depend scripts.
DEPEND_SCRIPTS=`ls ../depends/*.sh | sort`

## Run all the depend scripts.
for SCRIPT in $DEPEND_SCRIPTS; do "$SCRIPT" || { echo "$SCRIPT: Failed."; exit 1; } done

## Fetch the build scripts.
BUILD_SCRIPTS=`ls ../scripts/*.sh | sort`

## If specific steps were requested...
if [ $1 ]; then

  ## Find the requested build scripts.
  REQUESTS=""

  for STEP in $@; do
    SCRIPT=""
    for i in $BUILD_SCRIPTS; do
      if [ `basename $i | cut -d'-' -f1` -eq $STEP ]; then
        SCRIPT=$i
        break
      fi
    done

    [ -z $SCRIPT ] && { echo "ERROR: unknown step $STEP"; exit 1; }

    REQUESTS="$REQUESTS $SCRIPT"
  done

  ## Only run the requested build scripts
  BUILD_SCRIPTS="$REQUESTS"
fi

## Run the build scripts.
for SCRIPT in $BUILD_SCRIPTS; do "$SCRIPT" || { echo "$SCRIPT: Failed."; exit 1; } done
