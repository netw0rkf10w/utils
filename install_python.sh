#!/bin/bash
# Script for installing Python without root permission
# Requirements: openssl and libffi installed in ~/.local/

# exit on error
set -e

VERSION=3.7.7
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

# First install openssl
bash install_openssl.sh 1.1.1g ${PREFIX}

# The install libffi
bash install_libffi.sh

# installation directory
mkdir -p ${PREFIX}

# temporary directory
TMP=${HOME}/tmp_python_${VERSION}_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# download source files
FILENAME=Python-${VERSION}.tgz
if [ -f "${FILENAME}" ]; then
    echo "${FILENAME} exists. Skip downloading."
else
    wget https://www.python.org/ftp/python/${VERSION}/${FILENAME}
fi

# extract files, configure, and compile
# check openssl location: openssl version -a
# To install openssl: https://stackoverflow.com/a/49578644/2131200
echo "Extracting ${FILENAME}"
DIR=$(tar -tf ${FILENAME} | head -1 | cut -f1 -d"/")
tar -xzvf ${FILENAME}
echo "Enter ${DIR} and install"
cd ${DIR}
LDFLAGS=`pkg-config --libs-only-L libffi` ./configure --enable-shared --enable-optimizations --with-openssl=${HOME}/.local/openssl --prefix=${PREFIX}
make -j$(nproc)
make altinstall
cd ..

# cleanup
# rm -rf ${TMP}

echo "Done. Make sure to add this to your ~/.bashrc:"
echo "export PATH=${PREFIX}/bin:$""PATH"
echo "export LD_LIBRARY_PATH=${PREFIX}/lib:$""LD_LIBRARY_PATH"