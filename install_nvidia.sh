#!/bin/bash
# Script for installing CUDA 10.1 without root permission
# export PATH=$HOME/.local/cuda-10.1/bin:$HOME/.local/bin:$PATH
# export LD_LIBRARY_PATH=$HOME/.local/cuda-10.1/lib64:$HOME/.local/TensorRT-6.0.1.5/lib:$LD_LIBRARY_PATH

# exit on error
set -e

# installation directory
mkdir -p $HOME/.local

# temporary directory
TMP=$HOME/tmp_nvidia_4zf89YDf
mkdir -p ${TMP}
cd ${TMP}

# Install CUDA
sh cuda_10.1.243_418.87.00_linux.run  --silent --toolkit --toolkitpath=$HOME/.local/cuda-10.1 --defaultroot=$HOME/.local/cuda-10.1

# Install cuDNN
tar -xzvf cudnn-10.1-linux-x64-v7.6.5.32.tgz
# IMPORTANT: do NOT use rsync like this: rsync -a cuda/ $HOME/.local/cuda-10.1/
# that will erase existing files in $HOME/.local/cuda-10.1/
cp cuda/include/cudnn.h $HOME/.local/cuda-10.1/include
cp cuda/lib64/libcudnn* $HOME/.local/cuda-10.1/lib64

# Install TensorRT
tar -xzvf TensorRT-6.0.1.5.Ubuntu-16.04.x86_64-gnu.cuda-10.1.cudnn7.6.tar.gz -C $HOME/.local/
echo "Make sure to add library path: export LD_LIBRARY_PATH=<$>HOME/.local/TensorRT-6.0.1.5/lib>:<$>LD_LIBRARY_PATH"

cd $HOME/.local/TensorRT-6.0.1.5/python
pip install tensorrt-6.0.1.5-cp36-none-linux_x86_64.whl

cd $HOME/.local/TensorRT-6.0.1.5/uff
pip install uff-0.6.5-py2.py3-none-any.whl
which convert-to-uff

cd $HOME/.local/TensorRT-6.0.1.5//graphsurgeon
pip install graphsurgeon-0.4.1-py2.py3-none-any.whl