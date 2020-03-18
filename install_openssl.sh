#!/bin/bash
# Script for installing openssl without root permission

# exit on error
set -e

# installation directory
mkdir -p $HOME/.local

# temporary directory
TMP=${HOME}/tmp_openssl_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# download source files
VERSION=1.1.1e
FILENAME=openssl-${VERSION}.tar.gz
if [ -f "${FILENAME}" ]; then
    echo "${FILENAME} exists. Skip downloading."
else
    wget https://www.openssl.org/source/${FILENAME}
fi

# extract files, configure, and compile
# check openssl location: openssl version -a
# To install openssl: https://stackoverflow.com/a/49578644/2131200
echo "Extracting ${FILENAME}"
DIR=$(tar -tf ${FILENAME} | head -1 | cut -f1 -d"/")
tar -xzvf ${FILENAME}
echo "Enter ${DIR} and install"
cd ${DIR}
./config --prefix=${HOME}/.local/openssl --openssldir=${HOME}/.local/openssl
make -j$(nproc)
# make test
make install
cd ..

# cleanup
# rm -rf ${TMP}

echo "Done. Make sure to add this to your ~/.bashrc:"
echo "export PATH=$""HOME/.local/openssl/bin:$""PATH"
echo "export LD_LIBRARY_PATH=$""HOME/.local/openssl/lib:$""LD_LIBRARY_PATH"