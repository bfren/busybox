#!/bin/bash

set -euo pipefail

# script receives two arguments: the busybox version and Alpine branch
BUSYBOX=${1}
ALPINE_BRANCH=${2}

# download and extract source
wget https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2
tar -xf busybox-${BUSYBOX}.tar.bz2

# create 'a' and 'b' directories for patching
mv busybox-${BUSYBOX} a
cp -R a b

# download patches from Alpine
mkdir patches && cd patches
git init
git remote add -f origin https://gitlab.alpinelinux.org/alpine/aports.git
git config core.sparseCheckout true
echo "main/busybox/" >> .git/info/sparse-checkout
git switch ${ALPINE_BRANCH}-stable
