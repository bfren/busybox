# BusyBox

[BusyBox](https://busybox.net) compiled for different Alpine &amp; Debian versions, with default config (Alpine itself excludes certain applets by default).

## Matrix

### Alpine

| BusyBox     | 3.15        | 3.16          | 3.17          | 3.18          | 3.19          | 3.20          |
| ----------- | :---------: | :-----------: | :-----------: | :-----------: | :-----------: | :-----------: |
| **1.33.2**  | &check;     | &check;       | &check;       | &check;       | &check;       | &check;       |
| **1.34.1**  | &check;     | &check;       | &check;       | &check;       | &check;       | &check;       |
| **1.35.0**  | &check;     | &check;       | &check;       | &check;       | &check;       | &check;       |
| **1.36.1**  | &check;     | &check;       | &check;       | &check;       | &check;       | &check;       |

### Debian

| BusyBox     | 10 (buster) | 11 (bullseye) | 12 (bookworm) |
| ----------- | :---------: | :-----------: | :-----------: |
| **1.33.2**  | &check;     | &check;       | &check;       |
| **1.34.1**  | &check;     | &check;       | &check;       |
| **1.35.0**  | &check;     | &check;       | &check;       |
| **1.36.1**  | &check;     | &check;       | &check;       |

## Usage

You can find live examples in my [Debian Docker image](https://github.com/bfren/docker-debian).

```Dockerfile
# set Debian version
ARG DEBIAN=12.7

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
