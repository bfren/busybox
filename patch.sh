#!/bin/sh

set -eu

# apply Alpine's patches to the busybox source, in the order listed in APKBUILD source=
cd busybox

PATCHES=$(awk '
    /^source="/ { f = 1; sub(/^source="/, "") }
    f {
        done = index($0, "\"") > 0
        gsub(/"/, "")
        for (i = 1; i <= NF; i++) {
            p = $i
            if (p ~ /::/) sub(/::.*/, "", p); else sub(/.*\//, "", p)
            if (p ~ /\.patch$/) print p
        }
        if (done) f = 0
    }
' ../patches/APKBUILD)

[ -n "${PATCHES}" ] || { echo "No patches found in APKBUILD" >&2; exit 1; }

for P in ${PATCHES} ; do
    echo "Applying ${P}"
    patch -p1 -N --no-backup-if-mismatch < "../patches/${P}"
done
