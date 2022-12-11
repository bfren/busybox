ARG DEBIAN=11.5
FROM debian:${DEBIAN} AS build

RUN apt update && apt install -y bzip2 gcc make

WORKDIR /tmp

ARG BUSYBOX=1.35.0
ADD https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 /tmp
RUN tar -xf busybox-${BUSYBOX}.tar.bz2 ; \
    cd busybox-${BUSYBOX} ; \
    make defconfig ; make ; \
    mv busybox /

FROM scratch as final
COPY --from=build /busybox /
