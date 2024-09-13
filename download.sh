#!/bin/sh

set -euo pipefail

# script receives one argument only: the busybox version
BUSYBOX=${1}

# download and extract source
wget https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2
tar -xf busybox-${BUSYBOX}.tar.bz2

# create 'a' and 'b' directories for patching
mv busybox-${BUSYBOX} a
cp -R a b
