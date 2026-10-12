#!/bin/sh

set -eu

# verify the source tree to be built is exactly pristine upstream source plus the patch series:
# apply the series to a fresh copy of the pristine source, then compare with the tree being built
rm -rf verify && tar -xf busybox-*.tar.bz2 && mv busybox-*/ verify

for P in $(cat patches/series) ; do
    patch -d verify -p1 -N -f -s -r - --no-backup-if-mismatch < "patches/${P}" \
        || { echo "Patch ${P} does not apply to pristine source" >&2; exit 1; }
done

diff -r verify busybox >/dev/null || {
    echo "Source tree differs from pristine source + patches:" >&2
    diff -rq verify busybox | head -20 >&2
    exit 1
}

rm -rf verify
echo "Verified $(wc -l < patches/series) patches applied"