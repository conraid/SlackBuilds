#!/bin/sh

config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then
    # toss the redundant copy
    rm $NEW
  fi
  # Otherwise, we leave the .new copy for the admin to consider...
}

# Keep same perms on rc.dovecot.new:
if [ -e etc/rc.d/rc.dovecot ]; then
  cp -a etc/rc.d/rc.dovecot etc/rc.d/rc.dovecot.new.incoming
  cat etc/rc.d/rc.dovecot.new > etc/rc.d/rc.dovecot.new.incoming
  mv etc/rc.d/rc.dovecot.new.incoming etc/rc.d/rc.dovecot.new
fi

config etc/rc.d/rc.dovecot.new
config etc/dovecot/dovecot.conf.new

# Bail if user isn't valid on your system
if ! grep -q "^dovecot:" etc/group ; then
    if ! grep -q ":202:" etc/group ; then
	chroot . groupadd -g 202 dovecot &>/dev/null
    else
	chroot . groupadd dovecot &>/dev/null
    fi
fi
if ! grep -q "^dovecot:" etc/passwd ; then
    if ! grep -q ":202:" etc/passwd ; then
	chroot . useradd -d /dev/null -s /bin/false -u 202 -g dovecot dovecot &>/dev/null
    else
	chroot . useradd -d /dev/null -s /bin/false -g dovecot dovecot &>/dev/null
    fi
fi
