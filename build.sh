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

# fail if the binary is dynamically linked
if readelf --dynamic busybox | grep -q NEEDED ; then
    echo "BusyBox is dynamically linked" >&2
    readelf --dynamic busybox | grep NEEDED >&2
    exit 1
fi

# check the binary runs
./busybox echo "BusyBox $(./busybox | head -n 1 | cut -d ' ' -f 2) is statically linked"

# move binary to root
mv busybox /
