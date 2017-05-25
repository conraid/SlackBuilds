#!/bin/bash -e

JOHNDIR=/usr/libexec/john
if grep -q '^flags.* sse2' /proc/cpuinfo; then
    ${JOHNDIR}/john-sse2 $*
elif grep -q '^flags.* mmx' /proc/cpuinfo; then
    ${JOHNDIR}/john-mmx $*
else
    ${JOHNDIR}/john $*
fi

