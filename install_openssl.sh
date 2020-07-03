#!/bin/bash
# Script for installing openssl without root permission

# exit on error
set -e

VERSION=1.1.1g
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

echo "Will install version ${VERSION} to ${PREFIX}"

# installation directory
mkdir -p ${PREFIX}

# temporary directory
TMP=${HOME}/tmp_openssl_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# download source files
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
./config --prefix=${PREFIX} --openssldir=${PREFIX}/openssl
make -j$(nproc)
# make test
# install_sw instead of install to not install the manual
make install_sw
cd ..

# cleanup
# rm -rf ${TMP}

echo "Done. Make sure to add this to your ~/.bashrc:"
echo "export PATH=$""HOME/.local/openssl/bin:$""PATH"
echo "export LD_LIBRARY_PATH=$""HOME/.local/openssl/lib:$""LD_LIBRARY_PATH"
echo "IMPORTANT: To let the new installation use existing CA-certificates, create a symbolic link to these certificates, e.g.:"
echo "ln -s /etc/ssl/certs $""HOME/.local/openssl/certs"