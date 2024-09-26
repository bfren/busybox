#!/bin/sh

set -euo pipefail

# build busybox from patched source
cd b
make defconfig
make

# move busybox binary to root
mv busybox /
