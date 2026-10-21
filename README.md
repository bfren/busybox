# BusyBox

[BusyBox](https://busybox.net) compiled for different Alpine & Debian versions, so I can have a consistent
set of applets across my Docker ecosystem.

- **Config:** BusyBox `defconfig` (Alpine itself excludes certain applets), with a small number of changes
  in [config.sh](config.sh).
- **Patches:** bug and security fixes from Alpine's [aports](https://gitlab.alpinelinux.org/alpine/aports/-/tree/master/main/busybox),
  applied in `APKBUILD` order. Alpine packaging patches (install locations, changed defaults, utmps support)
  are excluded — see [patches.exclude](patches.exclude).
- **Verification:** every build checks that the source compiled is exactly upstream BusyBox plus the applied
  patches, and fails if any patch is missing or anything else has changed.

| BusyBox    | Alpine patches from |
| ---------- | ------------------- |
| **1.36.1** | `3.20-stable`       |
| **1.37.0** | `3.24-stable`       |
| **1.38.0** | `master`            |

BusyBox 1.37.0 and 1.38.0 are marked as 'unstable' by BusyBox, and the Alpine patches for 1.38.0 come from the master branch for edge builds.

> [!NOTE]
> Before version `261012`, Alpine patches were downloaded but never applied to the compiled source, so
> earlier images are unpatched upstream BusyBox. Rebuild against `261012` or later to pick up the fixes.

## Matrix

### Alpine

| BusyBox     | 3.15        | 3.16          | 3.17          | 3.18          | 3.19          | 3.20          | 3.21          | 3.22          | 3.23          | 3.24          |
| ----------- | :---------: | :-----------: | :-----------: | :-----------: | :-----------: | :-----------: | :-----------: | :-----------: | :-----------: | :-----------: |
| **1.36.1**  | &check;     | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       |
| **1.37.0**  | &check;     | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       |
| **1.38.0**  | &check;     | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       | &check;       |

### Debian

| BusyBox     | 11 (bullseye) | 12 (bookworm) | 13 (trixie) |
| ----------- | :-----------: | :-----------: | :---------: |
| **1.36.1**  | &check;       | &check;       | &check;     |
| **1.37.0**  | &check;       | &check;       | &check;     |
| **1.38.0**  | &check;       | &check;       | &check;     |

## Adding a release

1. Download `busybox-X.Y.Z.tar.bz2` from [busybox.net](https://busybox.net/downloads/) into [src](src).
2. Add the version to the `case` in [download.sh](download.sh), with the Alpine branch whose patches match it, and
   check [patches.exclude](patches.exclude) still covers Alpine's packaging patches.
3. Add the version to the `busybox` matrix in both [workflows](.github/workflows), and to the tables above.
4. Set [VERSION](VERSION) to today's date (`yymmdd`), run `./test.sh <alpine> <busybox>`, then run the
   `build-alpine` and `build-debian` workflows.

## Usage

You can find live examples in my [Alpine Docker image](https://github.com/bfren/docker-alpine) and [Debian Docker image](https://github.com/bfren/docker-debian).

```Dockerfile
# set Debian version
ARG DEBIAN=13.7
ARG VERSION=261012

# use tags to load correct version of BusyBox for your Debian version
FROM quay.io/bfren-bin/busybox:1.37.0-debian${DEBIAN}-${VERSION} AS busybox

# load the same version of Debian
FROM debian:${DEBIAN}-slim AS build

# copy busybox executable to /bin
COPY --from=busybox / /bin

# run install
RUN busybox --install

# rest of Dockerfile
```

## Licence

The build scripts in this repository are released under the [MIT licence](https://mit.bfren.dev/2022).

BusyBox is licensed under the [GNU General Public License v2 only](https://busybox.net/license.html).
The BusyBox source in [src](src), the Alpine patches applied to it, and the binaries in the published
images are all covered by that licence.
