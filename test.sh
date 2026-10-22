#!/bin/sh

BUSYBOX=${1:-1.37.0}

docker buildx build \
    --build-arg BUSYBOX=${BUSYBOX} \
    .
