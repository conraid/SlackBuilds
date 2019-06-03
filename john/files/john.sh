#!/bin/bash -e

JOHNDIR=/usr/libexec/john

if grep -q '^flags.* avx' /proc/cpuinfo && [ -x $JOHNDIR/john-avx ]; then
  ${JOHNDIR}/john-avx $*
elif grep -q '^flags.* oxp' /proc/cpuinfo && [ -x $JOHNDIR/john-oxp ] ; then
  ${JOHNDIR}/john-oxp $*
elif grep -q '^flags.* sse2' /proc/cpuinfo && [ -x $JOHNDIR/john-sse2 ] ; then
  ${JOHNDIR}/john-sse2 $*
elif grep -q '^flags.* mmx' /proc/cpuinfo && [ -x $JOHNDIR/john-mmx ]; then
  ${JOHNDIR}/john-mmx $*
else
  ${JOHNDIR}/john $*
fi

