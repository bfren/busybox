#!/bin/sh

set -euo pipefail

# script receives one argument only: the Alpine branch
ALPINE_BRANCH=${1}

# download patches from Alpine
mkdir patches && cd patches
git init
git remote add -f origin git://git.alpinelinux.org/aports.git
git config core.sparseCheckout true
echo "main/busybox/" >> .git/info/sparse-checkout
git switch ${ALPINE_BRANCH}-stable

# apply patches to busybox source
cd ..
for P in ./patches/main/busybox/*.patch
do 
    patch -tu -p0 -d . < ${P}
done

# build busybox from patched source
cd b
make defconfig
make

# move busybox binary to root
mv busybox /
