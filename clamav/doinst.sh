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

perms etc/rc.d/rc.clamav.new
config etc/logrotate.d/clamav.new
for NEW in etc/*.new; do
  config $NEW
done

# Remove new log if one is already present (thanks to SBo)
config var/log/clamav/clamd.log.new ; rm -f var/log/clamav/clamd.log.new
config var/log/clamav/freshclam.log.new ; rm -f var/log/clamav/freshclam.log.new

# Add user and group (uid=210 and gid=210 are SBo suggest)
if ! grep -q "^clamav:" etc/group; then
  if ! grep -q ":210:" etc/group; then
    chroot . groupadd -g 210 clamav &>/dev/null
  else
    chroot . groupadd clamav &>/dev/null
  fi
fi
if ! grep -q "^clamav:" etc/passwd; then
  if ! grep -q ":210:" etc/passwd; then
    chroot . useradd -u 210 -d /dev/null -s /bin/false -c "Clam AntiVirus" -g clamav clamav &>/dev/null
  else
    chroot . useradd -d /dev/null -s /bin/false -c "Clam AntiVirus" -g clamav clamav &>/dev/null
  fi
fi

echo "
*** NOTE ***
Run freshclam to download some virus definitions before starting clamav
"
