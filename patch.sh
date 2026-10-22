#!/bin/sh

set -eu

# apply the vendored patch series (written by update-patches.sh in APKBUILD order, packaging patches excluded)
cd busybox
for P in $(cat ../patches/series) ; do
    echo "Applying ${P}"
    patch -p1 -N --no-backup-if-mismatch < "../patches/${P}"
done
