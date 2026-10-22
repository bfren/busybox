#!/bin/sh

disable () {
    VAR=CONFIG_${1}
    sed -i -e "s/${VAR}=y/# ${VAR} is not set/g" .config
}

enable () {
    VAR=CONFIG_${1}
    sed -i -e "s/# ${VAR} is not set/${VAR}=y/g" .config
}

disable SHA1_HWACCEL
disable SHA256_HWACCEL
disable TC

# link statically against musl, so one binary runs on every Alpine and Debian version
enable STATIC
