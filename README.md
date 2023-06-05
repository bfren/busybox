# BusyBox

[BusyBox](https://busybox.net) compiled for different Debian versions.

## Matrix

| BusyBox | 9 (stretch) | 10 (buster) | 11 (bullseye) | 12 (bookworm) | testing (sid) |
| ------- | ----------- | ----------- | ------------- | ------------- | ------------- |
| 1.33.2  | ✓           | ✓           | ✓             | ✓             | ✓             |
| 1.34.1  | ✓           | ✓           | ✓             | ✓             | ✓             |
| 1.35.0  | ✓           | ✓           | ✓             | ✓             | ✓             |
| 1.36.1  | ×           | ✓           | ✓             | ✓             | ✓             |

## Usage

You can find live examples in my [Debian Docker image](https://github.com/bfren/docker-debian).

```Dockerfile
# set Debian version
ARG DEBIAN=11.7

# use tags to load correct version of BusyBox for your Debian version
FROM ghcr.io/bfren/busybox:1.36.1-debian${DEBIAN} AS busybox

# load the same the version of Debian
FROM debian:${DEBIAN}-slim AS build

# copy busybox executable to /bin
COPY --from=busybox / /bin

# run install
RUN busybox --install

# rest of Dockerfile
```
