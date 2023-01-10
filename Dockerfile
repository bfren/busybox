ARG DEBIAN=11.6
FROM debian:${DEBIAN} AS build

RUN apt update && apt install -y bzip2 gcc make wget

ARG BUSYBOX=1.36.0 
RUN cd /tmp && \
    wget https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 && \
    tar -xf busybox-${BUSYBOX}.tar.bz2 && \
    cd busybox-${BUSYBOX}
RUN make defconfig ; make
RUN mv busybox /

FROM scratch as final
COPY --from=build /busybox /
