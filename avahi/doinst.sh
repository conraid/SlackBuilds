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

perms etc/rc.d/rc.avahidaemon.new
perms etc/rc.d/rc.avahidnsconfd.new
perms etc/avahi/avahi-daemon.conf.new

# Add user and group (uid and gid are SBo suggests)
if ! grep -q "^avahi:" etc/group; then
    if ! grep -q ":214:" etc/group; then
        chroot . groupadd -g 214 avahi &>/dev/null
    else
        chroot . groupadd avahi &>/dev/null
    fi
fi

if ! grep -q "^avahi:" etc/passwd; then
    if ! grep -q ":214:" etc/passwd; then
        chroot . useradd -u 214 -g 214 -c "Avahi" -d /dev/null -s /bin/false avahi &>/dev/null
    else
        chroot . useradd -g avahi -c "Avahi" -d /dev/null -s /bin/false avahi &>/dev/null
    fi
fi
