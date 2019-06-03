#!/bin/bash -e

JOHNDIR=/usr/libexec/john

if grep -q '^flags.* avx' /proc/cpuinfo && [ -x $JOHNDIR/john-avx ]; then
  ${JOHNDIR}/john-avx $*
elif grep -q '^flags.* oxp' /proc/cpuinfo && [ -x $JOHNDIR/john-oxp ] ; then
  ${JOHNDIR}/john-oxp $*
else
  ${JOHNDIR}/john $*
fi

