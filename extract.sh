#!/bin/sh

set -eu

# script receives one argument: the busybox version
BUSYBOX=${1}

# patches are vendored in patches/<busybox> (see update-patches.sh) and copied in by the Dockerfile
[ -f patches/series ] || { echo "No vendored patches for BusyBox ${BUSYBOX}" >&2; exit 1; }
echo "Using Alpine patches for BusyBox ${BUSYBOX}:"
sed 's/^/    /' patches/SOURCE

# extract source
tar -xf busybox-${BUSYBOX}.tar.bz2
mv busybox-${BUSYBOX} busybox
