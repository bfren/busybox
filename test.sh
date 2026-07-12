#!/bin/sh

ALPINE=${1:-3.24.1}
ALPINE_BRANCH=${2:-3.24-stable}
BUSYBOX=${3:-1.37.0}

docker buildx build \
    -f Dockerfile.alpine \
    --build-arg ALPINE=${ALPINE} \
    --build-arg ALPINE_BRANCH=${ALPINE_BRANCH} \
    --build-arg BUSYBOX=${BUSYBOX} \
    .
