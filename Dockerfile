ARG DEBIAN=11.5
ARG BUSYBOX=1.35.0

FROM debian:${DEBIAN} AS build

WORKDIR /tmp

RUN echo "Debian: ${DEBIAN}" && \
    echo "Busybox: ${BUSYBOX}"
    
RUN apt update && apt install -y bzip2 curl gcc make

RUN curl -O https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 ; \
    tar -xf busybox-${BUSYBOX}.tar.bz2 ; \
    cd busybox-${BUSYBOX} ; \
    make defconfig ; make

FROM scratch as final
COPY --from=build /tmp/busybox-${BUSYBOX}/busybox /
