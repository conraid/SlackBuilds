#!/bin/bash

if [[ "$#" == '1' && "${1:0:1}" != '-' ]]; then
    exec /usr/share/gitkraken/gitkraken -p "$1"
else
    exec /usr/share/gitkraken/gitkraken "$@"
fi
