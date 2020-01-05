#!/bin/bash
# 
# exit on error
set -e

# # Extract debs into a directory
# if [ "$2" == "" ]; then echo "Usage : $0 <dir> <debs>" ; exit 1; fi

# DIR=`realpath $1`; shift
# DEBS=""
# while [ "$1" != "" ]; do DEBS=`realpath $1` ; shift; done
# echo $DEBS
# mkdir temp && cd temp
# for deb in $DEBS; do
#   ar x $deb && tar xf data.tar.xz
#   rm data.tar.xz control.tar.gz debian-binary
# done

# mkdir -p $DIR
# rsync -a usr/include/ $DIR/include/
# rsync -a usr/share/ $DIR/share/
# rsync -a usr/lib/x86_64-linux-gnu/ $DIR/lib/

# cd .. && rm -Rf temp


#
DIR=$HOME/.local

# Download the package from NVIDIA and change this path accordingly
VERSION=2.5.6
CUDA=10.1
DEB=$HOME/setup/nccl-repo-ubuntu1604-${VERSION}-ga-cuda${CUDA}_1-1_amd64.deb

# installation directory
mkdir -p $HOME/.local

# temporary directory
TMP=$HOME/tmp_nccl_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# Extract the main .deb
echo 'Extract '${DEB}'and its data'
ar x ${DEB} && tar xf data.tar.xz

cd ${TMP}/var/nccl-repo-${VERSION}-ga-cuda${CUDA}

# Extract and isntall libnccl-dev package
echo 'Extract and isntall libnccl-dev package'
ar x libnccl-dev_${VERSION}-1+cuda${CUDA}_amd64.deb
tar xf data.tar.xz
rsync -a usr/include/ $DIR/include/
rsync -a usr/share/ $DIR/share/
rsync -a usr/lib/x86_64-linux-gnu/ $DIR/lib/

# Extract and isntall libnccl package
echo 'Extract and isntall libnccl package'
cd ${TMP}/var/nccl-repo-${VERSION}-ga-cuda${CUDA}
ar x libnccl2_${VERSION}-1+cuda${CUDA}_amd64.deb
tar xf data.tar.xz
rsync -a usr/share/ $DIR/share/
rsync -a usr/lib/x86_64-linux-gnu/ $DIR/lib/

# cleanup
rm -rf ${TMP}

echo "Done. Make sure ${DIR} is added to your PATH."



