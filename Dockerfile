ARG DEBIAN=11.5
ARG BUSYBOX=1.35.0

FROM debian:${DEBIAN} AS build

WORKDIR /tmp

ENV VERSION=busybox-${BUSYBOX}

RUN echo "Debian: ${DEBIAN}" && \
    echo "Busybox: ${VERSION}"
RUN apt update && apt install -y bzip2 gcc make

ADD https://busybox.net/downloads/${VERSION}.tar.bz2 /tmp

RUN tar -xf ${VERSION}.tar.bz2 ; \
    cd ${VERSION} ; \
    make defconfig ; make

FROM scratch as final
COPY --from=build /tmp/${VERSION}/busybox /
