#!/bin/sh

ALPINE=${1:-3.23.2}
ALPINE_BRANCH=${2:-3.20}
BUSYBOX=${3:-1.36.1}

docker buildx build \
    -f Dockerfile.alpine \
    --build-arg ALPINE=${ALPINE} \
    --build-arg ALPINE_BRANCH=${ALPINE_BRANCH} \
    --build-arg BUSYBOX=${BUSYBOX} \
    .
