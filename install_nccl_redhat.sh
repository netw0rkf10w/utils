#!/bin/bash
# 
# exit on error
set -e

# installation directory
if [ $# -eq 1 ] then
    echo "Will install to "$1
else
    echo "You must provide an installation location, e.g. $HOME/.local"
    exit 1
fi

DIR=$1
mkdir -p $DIR

# You have to download the package from NVIDIA and change this path accordingly
# VERSION=2.5.6
# CUDA=10.1
# DEB=$HOME/setup/nccl-repo-rhel7-${VERSION}-ga-cuda${CUDA}-1-1.x86_64.rpm
# rpm2cpio ${DEB} | cpio -dimv
# cd var/nccl-repo-${VERSION}-ga-cuda${CUDA}/
# rpm2cpio libnccl-${VERSION}-1+cuda${CUDA}.x86_64.rpm | cpio -dimv
# rsync -a usr/ $DIR/

# temporary directory
# TMP=$HOME/tmp_nccl_4zf89YDf
# mkdir -p ${TMP}
# cd ${TMP}

rpm2cpio nccl-repo-rhel7-2.5.6-ga-cuda10.1-1-1.x86_64.rpm | cpio -dimv
cd var/nccl-repo-2.5.6-ga-cuda10.1

rpm2cpio libnccl-2.5.6-1+cuda10.1.x86_64.rpm | cpio -dimv
rpm2cpio libnccl-devel-2.5.6-1+cuda10.1.x86_64.rpm | cpio -dimv
rpm2cpio libnccl-static-2.5.6-1+cuda10.1.x86_64.rpm | cpio -dimv

rsync -a usr/ $HOME/.local/


# # Extract the main .deb
# echo 'Extract '${DEB}'and its data'
# ar x ${DEB} && tar xf data.tar.xz

# cd ${TMP}/var/nccl-repo-${VERSION}-ga-cuda${CUDA}

# # Extract and isntall libnccl-dev package
# echo 'Extract and isntall libnccl-dev package'
# ar x libnccl-dev_${VERSION}-1+cuda${CUDA}_amd64.deb
# tar xf data.tar.xz
# rsync -a usr/include/ $DIR/include/
# rsync -a usr/share/ $DIR/share/
# rsync -a usr/lib/x86_64-linux-gnu/ $DIR/lib/

# # Extract and isntall libnccl package
# echo 'Extract and isntall libnccl package'
# cd ${TMP}/var/nccl-repo-${VERSION}-ga-cuda${CUDA}
# ar x libnccl2_${VERSION}-1+cuda${CUDA}_amd64.deb
# tar xf data.tar.xz
# rsync -a usr/share/ $DIR/share/
# rsync -a usr/lib/x86_64-linux-gnu/ $DIR/lib/

# # cleanup
# rm -rf ${TMP}

# echo "Done. Make sure ${DIR} is added to your PATH."



