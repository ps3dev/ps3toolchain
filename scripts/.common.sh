#!/bin/sh
# .common.sh by Dustyn Gibson <miigotu@gmail.com>

#DEBUG=1

BINUTILS="binutils-2.22"
GCC="gcc-PS3"
GDB="gdb-7.5.1"
NEWLIB="newlib-1.20.0"

TOOLCHAIN_ROOT=$(git rev-parse --show-toplevel)
[ -z $TOOLCHAIN_ROOT ] && { echo 'Could not get the root of the toolchain. Please use git clone rather than a source archive.' && exit 1; }

PS3DEV_SOURCES=${TOOLCHAIN_ROOT}/src
PS3DEV_SCRIPTS=${TOOLCHAIN_ROOT}/scripts
PS3DEV_DEPENDS=${TOOLCHAIN_ROOT}/depends

PROC=$(nproc --all 2> /dev/null)
([ -z ${PROC} ] || [ ${?} -eq 0 ] || [ ${PROC} -eq 0 ]) && PROC=4

SUBMODULE_UPDATE="git submodule update --init --recursive"
git ls-remote -h "$(git remote get-url origin)" > /dev/null
[ $? -eq 0 ] && SUBMODULE_UPDATE=${SUBMODULE_UPDATE}" --remote"

update_submodule() {
  [ -d ${PS3DEV_SOURCES}/$1 ] && ${SUBMODULE_UPDATE} ${PS3DEV_SOURCES}/$1
}

update_submodule config
BUILD_HOST=$(${PS3DEV_SOURCES}/config/config.guess)

if [ ${DEBUG-0} -eq 1 ]; then
    for i in BINUTILS GCC GDB NEWLIB BUILD_HOST TOOLCHAIN_ROOT PS3DEV_SOURCES PS3DEV_SCRIPTS PS3DEV_DEPENDS PROC SUBMODULE_UPDATE; do
      echo "$i = `eval echo \\$${i}`"
    done
fi
