FROM --platform=${BUILDPLATFORM} golang:alpine AS build

ARG BUSYBOX
ARG DEBIAN

FROM debian:bookworm AS busybox

RUN apt update && apt install -y bzip2 gcc make
ADD https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 /tmp

WORKDIR /tmp
RUN tar -xf busybox-${BUSYBOX}.tar.bz2
RUN cd busybox-${BUSYBOX} ; make defconfig ; make

FROM scratch as final
COPY --from=busybox /tmp/busybox-${BUSYBOX}/busybox /
