ARG DEBIAN=11.6
FROM debian:${DEBIAN} AS build

WORKDIR /tmp
RUN apt update && apt install -y bzip2 gcc make wget

ARG BUSYBOX=1.36.0 
RUN wget https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 && \
    tar -xf busybox-${BUSYBOX}.tar.bz2
RUN cd busybox-${BUSYBOX} ; \
    make defconfig && \
    make && \
    mv busybox /

FROM scratch as final
COPY --from=build /busybox /
