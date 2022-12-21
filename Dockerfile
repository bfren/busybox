ARG DEBIAN=11.6
FROM debian:${DEBIAN} AS build

RUN apt update && apt install -y bzip2 gcc make wget

ARG BUSYBOX=1.35.0 
RUN cd /tmp ; \
    wget -O busybox.tar.bz2 https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 ; \
    tar -xf busybox.tar.bz2 ; \
    cd busybox ; \
    make defconfig ; make ; \
    mv busybox /

FROM scratch as final
COPY --from=build /busybox /
