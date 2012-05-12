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

# Keep same perms on rc.tor.new:
if [ -e etc/rc.d/rc.tor ]; then
  cp -a etc/rc.d/rc.tor etc/rc.d/rc.tor.new.incoming
  cat etc/rc.d/rc.tor.new > etc/rc.d/rc.tor.new.incoming
  mv etc/rc.d/rc.tor.new.incoming etc/rc.d/rc.tor.new
fi

config etc/rc.d/rc.tor.new
config etc/tor/tor-tsocks.conf.new
config etc/tor/torrc.new

# Bail if user isn't valid on your system
if ! grep -q "^tor:" etc/group ; then
    if ! grep -q ":220:" etc/group ; then
	chroot . groupadd -g 220 tor &>/dev/null
    else
	chroot . groupadd tor &>/dev/null
    fi
fi
if ! grep -q "^tor:" etc/passwd ; then
    if ! grep -q ":220:" etc/passwd ; then
	chroot . useradd -d /dev/null -s /bin/false -c "The Onion Router" -u 220 -g tor tor &>/dev/null
    else
	chroot . useradd -d /dev/null -s /bin/false -c "The Onion Router" -g tor tor &>/dev/null
    fi
fi
