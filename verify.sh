#!/bin/sh

set -eu

# verify the source tree contains exactly the pristine source plus every applied patch:
# reverse each patch (in reverse order) on a scratch copy, then compare with pristine source
PATCHES=$(cat patches/series)
REVERSED=""
for P in ${PATCHES} ; do REVERSED="${P} ${REVERSED}" ; done

# pristine upstream source
rm -rf pristine && tar -xf busybox-*.tar.bz2 && mv busybox-*/ pristine

# scratch copy of the tree to be built
rm -rf verify && cp -R busybox verify
for P in ${REVERSED} ; do
    patch -d verify -p1 -R -f -s -r - --no-backup-if-mismatch < "patches/${P}" \
        || { echo "Patch ${P} is not applied to the source tree" >&2; exit 1; }
done

diff -r verify pristine >/dev/null || {
    echo "Source tree differs from pristine source + patches:" >&2
    diff -r verify pristine | head -20 >&2
    exit 1
}

rm -rf verify pristine
echo "Verified $(echo ${PATCHES} | wc -w) patches applied"