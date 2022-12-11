ARG DEBIAN=11.5
FROM debian:${DEBIAN} AS build

ARG BUSYBOX=1.35.0

WORKDIR /tmp
    
RUN apt update && apt install -y bzip2 ca-certificates curl gcc make

RUN curl -O https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 ; \
    tar -xf busybox-${BUSYBOX}.tar.bz2 ; \
    cd busybox-${BUSYBOX} ; \
    make defconfig ; make ; \
    mv busybox /

FROM scratch as final
COPY --from=build /busybox /
