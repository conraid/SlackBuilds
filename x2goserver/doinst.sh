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

# Update the desktop database:
if [ -x /usr/bin/update-desktop-database ]; then
  /usr/bin/update-desktop-database -q usr/share/applications > /dev/null 2>&1
fi

perms etc/rc.d/rc.x2goserver.new

# Add x2gouser user and group (uid=290 and gid=290 are SBo suggest)
if ! grep -q "^x2gouser:" etc/group; then
  if ! grep -q ":290:" etc/group; then
    chroot . groupadd -g 290 x2gouser &>/dev/null
  else
    chroot . groupadd x2gouser &>/dev/null
  fi
fi
if ! grep -q "^x2gouser:" etc/passwd; then
  if ! grep -q ":290:" etc/passwd; then
    chroot . useradd -u 290 -d /var/lib/x2go -M -s /bin/false -c "X2GO Remote Desktop" -g x2gouser x2gouser &>/dev/null
  else
    chroot . useradd -d /var/lib/x2go -M -s /bin/false -c "X2GO Remote Desktop" -g x2gouser x2gouser &>/dev/null
  fi
fi

# Add x2goprint and group (uid=291 and gid=291 are SBo suggest)
if ! grep -q "^x2goprint:" etc/group; then
  if ! grep -q ":291:" etc/group; then
    chroot . groupadd -g 291 x2goprint &>/dev/null
  else
    chroot . groupadd x2goprint &>/dev/null
  fi
fi
if ! grep -q "^x2goprint:" etc/passwd; then
  if ! grep -q ":291:" etc/passwd; then
    chroot . useradd -u 291 -d /var/spool/x2goprint -M -s /bin/false -c "X2GO Remote Desktop" -g x2goprint x2goprint &>/dev/null
  else
    chroot . useradd -d /var/spool/x2goprint -M -s /bin/false -c "X2GO Remote Desktop" -g x2goprint x2goprint &>/dev/null
  fi
fi
