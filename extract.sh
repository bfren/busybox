#!/bin/sh

set -eu

# script receives one argument: the busybox version
BUSYBOX=${1}

# patches are vendored in patches/<busybox> (see update-patches.sh) and copied in by the Dockerfile
[ -f patches/series ] || { echo "No vendored patches for BusyBox ${BUSYBOX}" >&2; exit 1; }
echo "Using Alpine patches for BusyBox ${BUSYBOX}:"
sed 's/^/    /' patches/SOURCE

# check the tarball is exactly the one upstream publishes (hashes match Alpine's APKBUILD sha512sums)
SUM=$(grep " busybox-${BUSYBOX}.tar.bz2$" SHA512SUMS) || { echo "No checksum for busybox-${BUSYBOX}.tar.bz2 in SHA512SUMS" >&2; exit 1; }
echo "${SUM}" | sha512sum -c -

# extract source
tar -xf busybox-${BUSYBOX}.tar.bz2
mv busybox-${BUSYBOX} busybox
