ARG DEBIAN=11.5
ARG BUSYBOX=1.35.0

FROM debian:${DEBIAN} AS build

RUN apt update && apt install -y bzip2 gcc make
ADD https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 /tmp

WORKDIR /tmp
RUN tar -xf busybox-${BUSYBOX}.tar.bz2
RUN cd busybox-${BUSYBOX} ; make defconfig ; make

FROM scratch as final
COPY --from=build /tmp/busybox-${BUSYBOX}/busybox /
