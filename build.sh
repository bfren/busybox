#!/bin/sh

set -eu

# build busybox from patched source
cd b
cp ../.config .
make

# move busybox binary to root
mv busybox /
