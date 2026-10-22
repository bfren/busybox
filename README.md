# BusyBox

[BusyBox](https://busybox.net) statically linked against musl, so one binary gives a consistent set of applets
across every Alpine and Debian image in my Docker ecosystem.

- **Config:** BusyBox `defconfig` (Alpine itself excludes certain applets), with a small number of changes
  in [config.sh](config.sh).
- **Patches:** bug and security fixes from Alpine's [aports](https://gitlab.alpinelinux.org/alpine/aports/-/tree/master/main/busybox),
  vendored in [patches](patches) and applied in `APKBUILD` order (recorded in each version's `series`). Alpine
  packaging patches (install locations, changed defaults, utmps support) are excluded when vendoring - see
  [patches.exclude](patches.exclude). Each version's `SOURCE` file records the aports commit the patches were taken
  from, so builds never download anything.
- **Verification:** every build checks that the source compiled is exactly upstream BusyBox plus the applied
  patches, and fails if any patch is missing or anything else has changed.
- **Static:** every build fails if the binary has any dynamic library dependencies, so it runs on any Alpine or
  Debian version (and any other Linux) without needing matching libraries.

| BusyBox    | Alpine patches from |
| ---------- | ------------------- |
| **1.36.1** | `3.20-stable`       |
| **1.37.0** | `3.24-stable`       |
| **1.38.0** | `master`            |

BusyBox 1.37.0 and 1.38.0 are marked as 'unstable' by BusyBox, and the Alpine patches for 1.38.0 come from the master branch for edge builds.

> [!NOTE]
> Before version `261012`, Alpine patches were downloaded but never applied to the compiled source, so
> earlier images are unpatched upstream BusyBox. Rebuild against `261012` or later to pick up the fixes.

## Images

Images are published for `linux/amd64`, `linux/arm64` and `linux/arm/v7`, tagged `<busybox>-<version>`, e.g.
`quay.io/bfren-bin/busybox:1.37.0-261022`.

> [!NOTE]
> Before version `261022`, BusyBox was dynamically linked and built separately for each Alpine and Debian version,
> with tags like `1.37.0-alpine3.24.2-261012`. Those images remain available but will not be updated.

## Adding a release

1. Download `busybox-X.Y.Z.tar.bz2` from [busybox.net](https://busybox.net/downloads/) into [src](src).
2. Add the version to the `case` in [update-patches.sh](update-patches.sh), with the Alpine branch whose patches
   match it, run `./update-patches.sh <busybox>`, and check [patches.exclude](patches.exclude) still covers Alpine's
   packaging patches.
3. Add the version to both `busybox` matrices in the [build workflow](.github/workflows/build.yml), and to
   the table above.
4. Set [VERSION](VERSION) to today's date (`yymmdd`), run `./test.sh <busybox>`, then run the `build` workflow.

## Updating patches

Run `./update-patches.sh <busybox>` to refresh a version's vendored patches from the
[GitHub mirror of aports](https://github.com/alpinelinux/aports), review the diff, then bump [VERSION](VERSION)
and rebuild as above.

## Usage

You can find live examples in my [Alpine Docker image](https://github.com/bfren/docker-alpine) and [Debian Docker image](https://github.com/bfren/docker-debian).

```Dockerfile
# load BusyBox
FROM quay.io/bfren-bin/busybox:1.37.0-261022 AS busybox

# use any version of Alpine or Debian
FROM debian:13.7-slim AS build

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
