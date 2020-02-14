#!/bin/bash
# Script for installing Python without root permission
# https://www.iram.fr/IRAMFR/GILDAS/doc/html/gildas-python-html/node36.html

# exit on error
set -e

# installation directory
mkdir -p $HOME/.local

# temporary directory
TMP=$HOME/tmp_python_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# download source files
VERSION=3.7.6
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
./configure --enable-shared --enable-optimizations --with-ssl --prefix=$HOME/.local
make -j$(nproc)
make altinstall
cd ..

# cleanup
# rm -rf ${TMP}

echo "Done. Make sure to add this to your ~/.bashrc:"
echo "export PATH=$""HOME/.local/bin:$""PATH"
echo "export LD_LIBRARY_PATH=$""HOME/.local/lib:$""LD_LIBRARY_PATH"