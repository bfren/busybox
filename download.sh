#!/bin/sh

set -eu

# script receives two arguments: the busybox version and Alpine branch
BUSYBOX=${1}
ALPINE_BRANCH=${2}

# extract source
tar -xf busybox-${BUSYBOX}.tar.bz2
mv busybox-${BUSYBOX} busybox

# download patches (and APKBUILD) from Alpine
git clone --depth 1 --branch ${ALPINE_BRANCH} --single-branch https://gt.bfn.sh/bcg/aports.git
mkdir patches
mv aports/main/busybox/* patches/ && rm -rf aports