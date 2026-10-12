#!/bin/sh

set -eu

# verify patches
./verify.sh

# build default config
cd busybox
make defconfig
cp ../config.sh . && ./config.sh

# build busybox from patched source
make

# move binary to root
mv busybox /
