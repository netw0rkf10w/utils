#!/bin/bash
# Script for installing libffi without root permission

# exit on error
set -e

# installation directory
mkdir -p $HOME/.local

# temporary directory
TMP=${HOME}/tmp_libffi_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# download source files
VERSION=3.3
FILENAME=libffi-${VERSION}.tar.gz
if [ -f "${FILENAME}" ]; then
    echo "${FILENAME} exists. Skip downloading."
else
    wget https://github.com/libffi/libffi/releases/download/v${VERSION}/${FILENAME}
fi

# extract files, configure, and compile
# check openssl location: openssl version -a
# To install openssl: https://stackoverflow.com/a/49578644/2131200
echo "Extracting ${FILENAME}"
DIR=$(tar -tf ${FILENAME} | head -1 | cut -f1 -d"/")
tar -xzvf ${FILENAME}
echo "Enter ${DIR} and install"
cd ${DIR}
./configure --prefix=${HOME}/.local/libffi --disable-docs
make -j$(nproc)
make install
cd ..

# cleanup
# rm -rf ${TMP}

echo "Done. Make sure to add this to your ~/.bashrc:"
echo "export PKG_CONFIG_PATH=$""HOME/.local/libffi/lib/pkgconfig:$""PKG_CONFIG_PATH"
echo "export LD_LIBRARY_PATH=$""HOME/.local/libffi/lib:$""LD_LIBRARY_PATH"