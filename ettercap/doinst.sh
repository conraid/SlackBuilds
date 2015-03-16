#!/bin/sh

config() {
  NEW="$1"
  OLD="`dirname $NEW`/`basename $NEW .new`"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "`cat $OLD | md5sum`" = "`cat $NEW | md5sum`" ]; then # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

# Update the desktop database:
if [ -x usr/bin/update-desktop-database ]; then
	chroot . /usr/bin/update-desktop-database -q /usr/share/applications > /dev/null 2>&1
fi

config etc/ettercap/etter.conf.new
config etc/ettercap/etter.dns.new
config etc/ettercap/etter.mdns.new
config etc/ettercap/etter.nbns.new

