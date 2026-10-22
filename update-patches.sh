#!/bin/sh

set -eu

# Refresh the vendored Alpine patches for one BusyBox version from the GitHub mirror of aports.
# Run locally, review the diff, then commit - builds never download patches themselves.
#
#   ./update-patches.sh <busybox>

BUSYBOX=${1:?Usage: ./update-patches.sh <busybox>}

# Alpine branch whose patches match this busybox version
case "${BUSYBOX}" in
    1.36.1) ALPINE_BRANCH=3.20-stable ;;
    1.37.0) ALPINE_BRANCH=3.24-stable ;;
    1.38.0) ALPINE_BRANCH=master ;;
    *) echo "No Alpine patch branch defined for BusyBox ${BUSYBOX}" >&2; exit 1 ;;
esac

REPO=https://github.com/alpinelinux/aports.git
DEST=patches/${BUSYBOX}
TMP=$(mktemp -d)
trap 'rm -rf "${TMP}"' EXIT

# fetch only main/busybox from the branch
git clone --quiet --filter=blob:none --no-checkout --depth 1 --branch "${ALPINE_BRANCH}" --single-branch "${REPO}" "${TMP}"
git -C "${TMP}" sparse-checkout set --no-cone /main/busybox/
git -C "${TMP}" checkout --quiet
SRC=${TMP}/main/busybox

# check the branch packages the version we expect
PKGVER=$(sed -n 's/^pkgver=//p' "${SRC}/APKBUILD")
[ "${PKGVER}" = "${BUSYBOX}" ] || { echo "Alpine ${ALPINE_BRANCH} packages BusyBox ${PKGVER}, not ${BUSYBOX}" >&2; exit 1; }

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
' "${SRC}/APKBUILD")
[ -n "${ALL}" ] || { echo "No patches found in APKBUILD" >&2; exit 1; }

# vendor only the patches that will be applied (matched without the NNNN- prefix), recording them as the series
EXCLUDE=$(tr -d '\r' < patches.exclude | grep -v -e '^#' -e '^[[:space:]]*$' || true)
rm -rf "${DEST}" && mkdir -p "${DEST}"
: > "${DEST}/series"
for P in ${ALL} ; do
    NAME=${P#[0-9][0-9][0-9][0-9]-}
    if printf '%s\n' "${EXCLUDE}" | grep -qxF "${NAME}" ; then
        echo "Excluding ${P}"
    else
        cp "${SRC}/${P}" "${DEST}/"
        echo "${P}" >> "${DEST}/series"
    fi
done

# record where the patches came from
COMMIT=$(git -C "${TMP}" rev-parse HEAD)
DATE=$(git -C "${TMP}" log -1 --format=%cs)
PKGREL=$(sed -n 's/^pkgrel=//p' "${SRC}/APKBUILD")
cat > "${DEST}/SOURCE" <<SOURCE
repository: ${REPO}
branch: ${ALPINE_BRANCH}
commit: ${COMMIT}
date: ${DATE}
package: busybox-${PKGVER}-r${PKGREL}
SOURCE

echo "Vendored $(wc -l < "${DEST}/series" | tr -d ' ') patches for BusyBox ${BUSYBOX} from Alpine ${ALPINE_BRANCH} (${COMMIT})"
git status --short -- "${DEST}" 2>/dev/null || true
