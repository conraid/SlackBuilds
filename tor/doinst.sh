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

perms() {
    # Keep same perms on file
    NEW="$1"
    OLD="$(dirname $NEW)/$(basename $NEW .new)"
    if [ -e $OLD ]; then
        cp -a $OLD $NEW.incoming
        cat $NEW > $NEW.incoming
        mv $NEW.incoming $NEW
    fi
    config $NEW
}

perms etc/rc.d/rc.tor.new
config etc/tor/torrc.new
config etc/logrotate.d/tor.new

# Add user and group (uid=220 and gid=220 are SBo suggest)
if ! getent group tor 2>&1 > /dev/null; then
    if ! getent group 220 2>&1 > /dev/null; then
        chroot . groupadd -g 220 tor &>/dev/null
    else
        chroot . groupadd tor &>/dev/null
    fi
fi

if ! getent passwd tor 2>&1 > /dev/null; then
    if ! getent passwd 220 2>&1 > /dev/null; then
        chroot . useradd -u 220 -d /dev/null -s /bin/false -c "The Onion Router" -g tor tor &>/dev/null
    else
        chroot . useradd -d /dev/null -s /bin/false -c "The Onion Router" -g tor tor &>/dev/null
    fi
fi
