# BusyBox

[BusyBox](https://busybox.net) compiled for different Debian versions.

## Matrix

| BusyBox | 10 (buster) | 11 (bullseye) | 12 (bookworm) | sid      |
| ------- | ----------- | ------------- | ------------- | -------- |
| 1.33.2  | &#x2611;    | &#x2611;      | &#x2611;      | &#x2611; |
| 1.34.1  | &#x2611;    | &#x2611;      | &#x2611;      | &#x2611; |
| 1.35.0  | &#x2611;    | &#x2611;      | &#x2611;      | &#x2611; |

## Usage

```Dockerfile
# use tags to load correct version of BusyBox for your Debian version
FROM ghcr.io/bfren/busybox:1.35.0-debian11.5 AS busybox

# load the same the version of Debian
FROM debian:11.5-slim AS build

# copy busybox executable to /bin
COPY --from=busybox / /bin

# rest of Dockerfile
```
