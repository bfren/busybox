#!/bin/sh

set -eu

# list patches in the order given by APKBUILD source=
ALL=$(awk '
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
' patches/APKBUILD)

[ -n "${ALL}" ] || { echo "No patches found in APKBUILD" >&2; exit 1; }

# remove excluded patches (matched without the NNNN- prefix), recording the rest as the series
EXCLUDE=$(tr -d '\r' < patches.exclude | grep -v -e '^#' -e '^[[:space:]]*$' || true)
: > patches/series
for P in ${ALL} ; do
    NAME=${P#[0-9][0-9][0-9][0-9]-}
    if printf '%s\n' "${EXCLUDE}" | grep -qxF "${NAME}" ; then
        echo "Excluding ${P}"
    else
        echo "${P}" >> patches/series
    fi
done

# apply patches
cd busybox
for P in $(cat ../patches/series) ; do
    echo "Applying ${P}"
    patch -p1 -N --no-backup-if-mismatch < "../patches/${P}"
done