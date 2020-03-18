#!/bin/sh

VERSION=$(ar p skypeforlinux-64.deb control.tar.gz | tar zxO ./control | grep Version | awk '{print $2}' | cut -d- -f1)
echo $VERSION
