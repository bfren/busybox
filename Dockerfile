ARG DEBIAN=11.6

# use target Debian version as host
FROM debian:${DEBIAN} AS build

# install prerequisites
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt update && \
    apt install -y bzip2 gcc make wget zip

# download busybox source
ARG BUSYBOX=1.36.0 
WORKDIR /tmp
RUN wget https://busybox.net/downloads/busybox-${BUSYBOX}.tar.bz2 && \
    tar -xf busybox-${BUSYBOX}.tar.bz2

# build and test busybox binary
WORKDIR /tmp/busybox-${BUSYBOX}
COPY .config .
RUN make && \
    cd testsuite && \
    SKIP_KNOWN_BUGS=true ./runtest && \
    mv busybox /

# create blank image with only busybox binary
FROM scratch as final
COPY --from=build /busybox /
