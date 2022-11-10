#!/bin/bash
# Script for installing libffi without root permission

# exit on error
set -e

VERSION=2.1.4
PREFIX=${HOME}/.local
# Check number of arguments
if [ $# -gt 1 ]
then
    VERSION=$1
    PREFIX=$2
elif [ $# -gt 0 ]
then
    VERSION=$1
else
    echo "No arguments provided. Default values will be used."
fi

echo "Will install jpeg-turbo version ${VERSION} to ${PREFIX}"

# installation directory
mkdir -p ${PREFIX}

# temporary directory
TMP=/tmp/tmp_jpeg-turbo_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# download source files
FILENAME=${VERSION}.tar.gz
if [ -f "${FILENAME}" ]; then
    echo "${FILENAME} exists. Skip downloading."
else
    wget https://github.com/libjpeg-turbo/libjpeg-turbo/archive/refs/tags/${FILENAME}
fi

# extract files, configure, and compile
# check openssl location: openssl version -a
# To install openssl: https://stackoverflow.com/a/49578644/2131200
echo "Extracting ${FILENAME}"
DIR=$(tar -tf ${FILENAME} | head -1 | cut -f1 -d"/")
tar -xzvf ${FILENAME}
echo "Enter ${DIR} and install"
cd ${DIR}
mkdir build
cd build
cmake -G"Unix Makefiles" .. -D CMAKE_BUILD_TYPE=Release -D CMAKE_INSTALL_PREFIX=${PREFIX}
make -j$(nproc)
# make DESTDIR=${PREFIX} install
make install
cd ..

# cleanup
# rm -rf ${TMP}

echo "Done. Make sure to add this to your ~/.bashrc:"
echo "export PKG_CONFIG_PATH=$""HOME/.local/lib/pkgconfig:$""PKG_CONFIG_PATH"
echo "export LD_LIBRARY_PATH=$""HOME/.local/lib:$""LD_LIBRARY_PATH"