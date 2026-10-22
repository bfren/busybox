# BusyBox is statically linked against musl, so the Alpine version used to build it does not matter:
# the same binary is used by every Alpine and Debian image
ARG ALPINE=3.24.2
FROM alpine:${ALPINE} AS build

ARG BUSYBOX=1.37.0

RUN apk add alpine-sdk linux-headers perl

WORKDIR /tmp
COPY ./download.sh ./patch.sh ./patches.exclude ./config.sh ./verify.sh ./build.sh ./
COPY ./src/busybox-${BUSYBOX}.tar.bz2 .
RUN chmod +x ./*.sh

RUN ./download.sh ${BUSYBOX}
RUN ./patch.sh
RUN ./build.sh

FROM scratch AS final

COPY --from=build /busybox /
