ARG OS=debian:${DEBIAN}
ARG BUSYBOX=busybox-${VERSION}

FROM ${OS} AS build

RUN apt update && apt install -y bzip2 gcc make
ADD https://busybox.net/downloads/${BUSYBOX}.tar.bz2 /tmp

WORKDIR /tmp
RUN tar -xf ${BUSYBOX}.tar.bz2
RUN cd ${BUSYBOX} ; make defconfig ; make

FROM scratch as final
COPY --from=build /tmp/${BUSYBOX}/busybox /
