#!/bin/sh

curl -I -L -s https://www.dropbox.com/download?plat=lnx.x86_64 | grep location | rev | cut -d- -f1 | cut -d. -f3- | rev

