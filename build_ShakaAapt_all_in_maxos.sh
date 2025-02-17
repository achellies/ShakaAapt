#! /bin/bash

export Project=ShakaAapt
export BUILD_NUMBER=$Project.$(date +%Y%m%d.%H%M%S)
export BinDir=ShakaAaptBin

export USE_CCACHE=1
export CCACHE_DIR=$(pwd)/.ccache
prebuilts/misc/darwin-x86/ccache/ccache -M 50G
. build/envsetup.sh
lunch sdk-eng

# darwin-x86

OUT_DIR=out-x86 make -B BUILD_NUMBER=$BUILD_NUMBER LOCAL_MULTILIB=32 aapt -j4
mkdir -p "$BinDir/darwin-x86/bin"
mkdir -p lib "$BinDir/darwin-x86/lib"
cp out-x86/host/darwin-x86/bin/aapt "$BinDir/darwin-x86/bin/aapt"
cp out-x86/host/darwin-x86/lib/libc++.dylib "$BinDir/darwin-x86/lib/libc++.dylib"

# darwin-x86_64

OUT_DIR=out-x86_64 make -B BUILD_NUMBER=$BUILD_NUMBER LOCAL_MULTILIB=64 aapt -j4
mkdir -p "$BinDir/darwin-x86_64/bin"
mkdir -p "$BinDir/darwin-x86_64/lib64/"
cp out-x86_64/host/darwin-x86/bin/aapt "$BinDir/darwin-x86_64/bin/aapt"
cp out-x86_64/host/darwin-x86/lib64/libc++.dylib "$BinDir/darwin-x86_64/lib64/libc++.dylib"

