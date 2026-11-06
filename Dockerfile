# BusyBox is statically linked against musl, so the Alpine version used to build it does not matter:
# the same binary is used by every Alpine and Debian image
ARG ALPINE=3.24.3
FROM alpine:${ALPINE} AS build

ARG BUSYBOX=1.37.0
# NATIVE is false when built using QEMU, which cannot run the test suite reliably
ARG NATIVE=true
ARG CHECK=${NATIVE}

# zip is needed by the BusyBox test suite
RUN apk add build-base linux-headers perl zip

WORKDIR /tmp
COPY ./extract.sh ./patch.sh ./config.sh ./build.sh ./check.known-failures ./
COPY ./src/SHA512SUMS ./src/busybox-${BUSYBOX}.tar.bz2 ./
COPY ./patches/${BUSYBOX}/ ./patches/
RUN chmod +x ./*.sh

RUN ./extract.sh ${BUSYBOX}
RUN ./patch.sh
RUN ./build.sh

FROM scratch AS final

COPY --from=build /busybox /
