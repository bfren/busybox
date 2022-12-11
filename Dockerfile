FROM debian:$OS AS build

RUN apt update && apt install -y bzip2 gcc make
ADD https://busybox.net/downloads/busybox-$VERSION.tar.bz2 /tmp

WORKDIR /tmp
RUN tar -xf busybox-$VERSION.tar.bz2
RUN cd busybox-$VERSION ; make defconfig ; make

FROM scratch as final
COPY --from=build /tmp/busybox-$VERSION/busybox /
