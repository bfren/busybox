#!/bin/sh

set -eu

# build busybox from patched source
cd b
make defconfig
chmod +x ./config.sh && ./config.sh
make

# move busybox binary to root
mv busybox /
