#!/bin/sh

set -eu

# script receives two arguments: the busybox version and Alpine branch
BUSYBOX=${1}
ALPINE_BRANCH=${2}

# extract source
tar -xf busybox-${BUSYBOX}.tar.bz2

# create 'a' and 'b' directories for patching
mv busybox-${BUSYBOX} a
cp -R a b

# download patches
mkdir patches

# .. from Alpine
git clone --depth 1 -b ${ALPINE_BRANCH}-stable https://gitlab.alpinelinux.org/alpine/aports.git
mv aports/main/busybox/* patches/ && rm -rf aports

# .. from Docker
git clone --depth 1 https://github.com/docker-library/busybox.git
mv busybox/.patches/* patches/ && rm -rf busybox
