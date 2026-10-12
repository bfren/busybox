#!/bin/sh

ALPINE=${1:-3.24.2}
BUSYBOX=${3:-1.37.0}

docker buildx build \
    -f Dockerfile.alpine \
    --build-arg ALPINE=${ALPINE} \
    --build-arg BUSYBOX=${BUSYBOX} \
    .
