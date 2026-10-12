#!/bin/sh

set -eu

# build default config and modify
cd busybox
make defconfig
cp ../config.sh . && chmod +x ./config.sh && ./config.sh

# build busybox from patched source
make

# move binary to root
mv busybox /
