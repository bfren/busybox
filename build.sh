#!/bin/sh

set -eu

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

# run the BusyBox test suite as Alpine does (skipped under QEMU, where it is slow and unreliable)
if [ "${CHECK:-true}" = "true" ] ; then
    SHELL=/bin/sh SKIP_KNOWN_BUGS=1 make check > ../check.log 2>&1 || true
    grep -q '^PASS: ' ../check.log || { cat ../check.log >&2; echo "BusyBox test suite did not run" >&2; exit 1; }
    sed -n 's/^FAIL: //p' ../check.log | sort > ../check.failed
    grep -v -e '^#' -e '^[[:space:]]*$' ../check.known-failures | sort > ../check.known
    UNEXPECTED=$(comm -23 ../check.failed ../check.known)
    echo "Test suite: $(grep -c '^PASS: ' ../check.log) passed, $(wc -l < ../check.failed) failed ($(wc -l < ../check.known) known)"
    [ -z "${UNEXPECTED}" ] || { echo "Unexpected test failures:" >&2; echo "${UNEXPECTED}" >&2; exit 1; }
fi

# move binary to root
mv busybox /
