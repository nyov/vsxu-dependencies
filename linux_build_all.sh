#!/bin/bash

set -e

function cdir() {
        if [ -d "$1" ]; then
               rm -rf "$1"
        fi
        mkdir -p "$1"
}

export CC=gcc
export CXX=g++
export CPP=cpp
export AR=ar
export RANLIB=ranlib

if [ "x$TARGET_PATH" == "x" ]; then
   export TARGET_PATH=/tmp/local/dependencies-install_linux
   cdir "$TARGET_PATH"
fi

export PKG_CONFIG_PATH=$TARGET_PATH/lib/pkgconfig

# needs: libxmu-dev
pushd glew-1.7.0
CFLAGS="-DGLEW_STATIC=1 -static" GLEW_DEST=$TARGET_PATH make -j$CONCURRENT install
popd

pushd freetype-2.4.8
CFLAGS="-DFREETYPE_STATIC=1 -static" ./configure --prefix=$TARGET_PATH
make -j$CONCURRENT install
popd

pushd zlib-1.2.5
CFLAGS="-DZLIB_STATIC=1 -static" ./configure --prefix=$TARGET_PATH --64 --static
make -j$CONCURRENT install
popd

pushd glfw-2.7.2/lib/win32
make -f Makefile.win64.cross-mgww64 PREFIX=$TARGET_PATH install
popd

pushd jpeg-8c
CFLAGS="-DJPEG_STATIC=1 -static" ./configure --prefix=$TARGET_PATH --host=x86_64-linux-gnu --enable-static=yes --enable-shared=no
make -j$CONCURRENT install
popd

pushd SDL2-2.0.1
./configure --prefix=$TARGET_PATH --enable-static=yes --enable-shared=no
make -j$CONCURRENT install
popd

pushd curl-7.43.0
./configure --prefix=$TARGET_PATH --enable-static=yes --enable-shared=no
make -j$CONCURRENT install
popd

#pushd breakpad
#LIBS=-lws2_32 LDFLAGS=-static ./configure --prefix=$TARGET_PATH --disable-tools --enable-static
#make -j$CONCURRENT install
#popd

./linux_build_png.sh
