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


config usr/share/dbus-1/system.d/org.freedesktop.ColorManager.conf.new

if [ -e usr/share/glib-2.0/schemas ]; then
  if [ -x /usr/bin/glib-compile-schemas ]; then
    /usr/bin/glib-compile-schemas usr/share/glib-2.0/schemas >/dev/null 2>&1
  fi
fi

# Add user and group
# (303 uid and gid are SBo suggests https://slackbuilds.org/uid_gid.txt)
if ! grep -q "^colord:" etc/group; then
  if ! grep -q ":303:" etc/group; then
    chroot . groupadd -g 303 colord &>/dev/null
  else
    chroot . groupadd colord &>/dev/null
  fi
fi

if ! grep -q "^colord:" etc/passwd; then
  if ! grep -q ":303:" etc/passwd; then
    chroot . useradd -u 303 -s /bin/false -g colord colord &>/dev/null
  else
    chroot . useradd -s /bin/false -g colord colord &>/dev/null
  fi
fi
