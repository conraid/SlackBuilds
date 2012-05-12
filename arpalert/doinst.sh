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

# Keep same perms on rc.XXX.new:
if [ -e etc/rc.d/rc.arpalert ]; then
  cp -a etc/rc.d/rc.arpalert etc/rc.d/rc.arpalert.new.incoming
  cat etc/rc.d/rc.arpalert.new > etc/rc.d/rc.arpalert.new.incoming
  mv etc/rc.d/rc.arpalert.new.incoming etc/rc.d/rc.arpalert.new
else 
  chmod 0755 etc/rc.d/rc.arpalert.new
fi

config etc/arpalert/arpalert.conf.new
config etc/rc.d/rc.arpalert.new

# Add user and group
if ! grep -q "^arpalert:" etc/group; then
  chroot . groupadd arpalert &>/dev/null
fi

if ! grep -q "^arpalert:" etc/passwd; then
  chroot . useradd -d /var/lib/arpalert -s /bin/false -c "Arpalert" -g arpalert arpalert &>/dev/null
fi

# Set up home directory.
if [ -d var/lib/arpalert ]; then
    chown -R arpalert:arpalert var/lib/arpalert
    chmod -R 0750 var/lib/arpalert
fi
