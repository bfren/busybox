ARG DEBIAN=11.6

# use target Debian version as host
FROM debian:${DEBIAN} AS build

# install prerequisites
RUN apt update && apt install -y bzip2 gcc make wget zip

# download busybox source
ARG BUSYBOX=1.36.0 
WORKDIR /tmp
RUN wget https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 && \
    tar -xf busybox-${BUSYBOX}.tar.bz2

# build and test busybox binary
WORKDIR /tmp/busybox-${BUSYBOX}
RUN make defconfig && \
    make
RUN cd testsuite && \
    rm mount.tests taskset.tests && \
    SKIP_KNOWN_BUGS=true ./runtest
RUN mv busybox /

# create blank image with only busybox binary
FROM scratch as final
COPY --from=build /busybox /
