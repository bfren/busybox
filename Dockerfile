ARG OS=debian:${DEBIAN}
ARG VERSION=busybox-${BUSYBOX}

FROM ${OS} AS build

RUN apt update && apt install -y bzip2 gcc make
ADD https://busybox.net/downloads/${VERSION}.tar.bz2 /tmp

WORKDIR /tmp
RUN tar -xf ${VERSION}.tar.bz2
RUN cd ${VERSION} ; make defconfig ; make

FROM scratch as final
COPY --from=build /tmp/${VERSION}/busybox /
