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

config etc/bwctl/bwctld.conf.new
config etc/bwctl/bwctld.limits.new
perms etc/rc.d/rc.bwctld.new

# Add user and group
if ! grep -q "^bwctl:" etc/group; then
    if ! grep -q ":401:" etc/group; then
	chroot . groupadd -g 401 bwctl &>/dev/null
    else
	chroot . groupadd bwctl &>/dev/null
    fi
fi

if ! grep -q "^bwctl:" etc/passwd; then
    if ! grep -q ":401:" etc/passwd; then
	chroot . useradd -u 401 -d /dev/null -s /bin/false -c "bwctl" -g bwctl bwctl &>/dev/null
    else
	chroot . useradd -d /dev/null -s /bin/false -c "bwctl" -g bwctl bwctl &>/dev/null
    fi
fi

chown bwctl:bwctl var/run/bwctl

cat << EOF

  NOTE
  ----
  You will need to create an bwctld.conf file in /etc/bwctl/ before you can run
  bwctld. See the bwctld.conf(5) manual page and /etc/bwctl/bwctld.conf.sample
  file for details. You may also want to create bwctld.limits(5) and
  bwctld.pfs(5) files.
  ----

EOF
