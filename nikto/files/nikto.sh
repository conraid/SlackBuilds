#!/bin/bash
cd /usr/share/nikto
exec /usr/bin/perl nikto.pl "$@"
