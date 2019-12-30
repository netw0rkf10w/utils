#!/bin/bash
# Script for installing graphviz without root permission
# Note: if error: /usr/bin/ld: cannot find -lperl
# then locate libpearl using: ldconfig -p | grep libperl
# Create a symlink:
# ln -s /usr/lib/x86_64-linux-gnu/libperl.so.5.22 $HOME/.local/lib/libperl.so

# exit on error
set -e

# installation directory
mkdir -p $HOME/.local

# temporary directory
TMP=$HOME/tmp_graphviz_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# download source files
FILENAME=graphviz.tar.gz
if [ -f "${FILENAME}" ]; then
    echo "${FILENAME} exists. Skip downloading."
else
    wget https://graphviz.gitlab.io/pub/graphviz/stable/SOURCES/${FILENAME}
fi

# extract files, configure, and compile
echo "Extracting ${FILENAME}"
DIR=$(tar -tf ${FILENAME} | head -1 | cut -f1 -d"/")
tar -xzvf ${FILENAME}
echo "Enter ${DIR} and install"
cd ${DIR}
./configure --prefix=$HOME/.local
make -j8
make install
cd ..

# cleanup
rm -rf ${TMP}

echo "Done. Make sure $HOME/.local/bin is added to your PATH."