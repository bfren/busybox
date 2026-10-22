#!/bin/sh

set -eu

# script receives one argument: the busybox version
BUSYBOX=${1}

# Alpine branch whose patches match this busybox version
case "${BUSYBOX}" in
    1.36.1) ALPINE_BRANCH=3.20-stable ;;
    1.37.0) ALPINE_BRANCH=3.24-stable ;;
    1.38.0) ALPINE_BRANCH=master ;;
    *) echo "No Alpine patch branch defined for BusyBox ${BUSYBOX}" >&2; exit 1 ;;
esac
echo "Using Alpine ${ALPINE_BRANCH} patches for BusyBox ${BUSYBOX}"

# extract source
tar -xf busybox-${BUSYBOX}.tar.bz2
mv busybox-${BUSYBOX} busybox

# download patches (and APKBUILD) from Alpine
git clone --depth 1 --branch ${ALPINE_BRANCH} --single-branch https://git.bfren.dev/bcg/aports.git
mkdir patches
mv aports/main/busybox/* patches/ && rm -rf aports
