#!/bin/sh

disable () {
    VAR=CONFIG_${1}
    sed -i -e "s/${VAR}=y/# ${VAR} is not set/g" .config
}

disable TC
