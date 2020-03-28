#!/bin/bash
# Script for installing wget without root permission
# Requirements: openssl and libffi installed in ~/.local/

# exit on error
set -e

VERSION=latest
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
TMP=${HOME}/tmp_zlip_${VERSION}_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# download source files
FILENAME=wget-${VERSION}.tar.gz
if [ -f "${FILENAME}" ]; then
    echo "${FILENAME} exists. Skip downloading."
else
    wget https://ftp.gnu.org/gnu/wget/${FILENAME}
fi

# extract files, configure, and compile
# check openssl location: openssl version -a
# To install openssl: https://stackoverflow.com/a/49578644/2131200
echo "Extracting ${FILENAME}"
DIR=$(tar -tf ${FILENAME} | head -1 | cut -f1 -d"/")
tar -xzvf ${FILENAME}
echo "Enter ${DIR} and install"
cd ${DIR}
./configure --prefix=${PREFIX}
make -j$(nproc)
make install
cd ..

# cleanup
rm -rf ${TMP}

echo "Done. Make sure to add this to your ~/.bashrc:"
echo "export PATH=${PREFIX}/bin:$""PATH"
echo "export LD_LIBRARY_PATH=${PREFIX}/lib:$""LD_LIBRARY_PATH"
# export CPATH=$HOME/.local/include:$CPATH
echo "export CPATH=${PREFIX}/include:$""CPATH"