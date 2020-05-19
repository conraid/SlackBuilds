#!/bin/sh

VERSION=$(ar p $CWD/${PRGNAM}-64.deb control.tar.gz | tar -Ozxf - ./control | awk '/^Version:/{print $NF}')

echo $VERSION
