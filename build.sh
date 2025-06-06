#!/bin/sh

set -eu

# build default config and modify
cd b
make defconfig
cp ../config.sh . && chmod +x ./config.sh && ./config.sh

# build busybox from patched source and move binary to root
make
mv busybox /
