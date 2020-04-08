#!/bin/bash
# Script for installing tmux on systems where you don't have root access.
# Based on https://gist.github.com/ryin/3106801 with some modifications
# tmux will be installed in ${PREFIX}/bin.
# It's assumed that wget and a C/C++ compiler are installed.

# exit on error
set -e

TMUX_VERSION=3.0a
LIBEVENT_VERSION=2.1.11
NCURSES_VERSION=6.1
PREFIX=${HOME}/.local
# Check number of arguments
if [ $# -gt 1 ]
then
    TMUX_VERSION=$1
    PREFIX=$2
elif [ $# -gt 0 ]
then
    TMUX_VERSION=$1
else
    echo "No arguments provided. Default values will be used."
fi

echo "Will install tmux version ${TMUX_VERSION} to ${PREFIX}"

# create our directories
mkdir -p ${PREFIX} $HOME/tmux_tmp
cd $HOME/tmux_tmp

# download source files for tmux, libevent, and ncurses
wget https://github.com/tmux/tmux/releases/download/${TMUX_VERSION}/tmux-${TMUX_VERSION}.tar.gz
wget https://github.com/libevent/libevent/releases/download/release-${LIBEVENT_VERSION}-stable/libevent-${LIBEVENT_VERSION}-stable.tar.gz
wget https://invisible-mirror.net/archives/ncurses/ncurses-${NCURSES_VERSION}.tar.gz

# extract files, configure, and compile

############
# libevent #
############
tar xvzf libevent-${LIBEVENT_VERSION}-stable.tar.gz
cd libevent-${LIBEVENT_VERSION}-stable
./configure --prefix=${PREFIX} --disable-shared
make -j$(nproc)
make install
cd ..

############
# ncurses  #
############
tar xvzf ncurses-${NCURSES_VERSION}.tar.gz
cd ncurses-${NCURSES_VERSION}
./configure --prefix=${PREFIX}
make -j$(nproc)
make install
cd ..

############
# tmux     #
############
tar xvzf tmux-${TMUX_VERSION}.tar.gz
cd tmux-${TMUX_VERSION}
./configure CFLAGS="-I${PREFIX}/include -I${PREFIX}/include/ncurses" LDFLAGS="-L${PREFIX}/lib -L${PREFIX}/include/ncurses -L${PREFIX}/include"
CPPFLAGS="-I${PREFIX}/include -I${PREFIX}/include/ncurses" LDFLAGS="-static -L${PREFIX}/include -L${PREFIX}/include/ncurses -L${PREFIX}/lib" make
cp tmux ${PREFIX}/bin
cd ..

# cleanup
rm -rf $HOME/tmux_tmp

echo "${PREFIX}/bin/tmux is now available. You can optionally add ${PREFIX}/bin to your PATH."