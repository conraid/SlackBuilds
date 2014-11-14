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

perms etc/rc.d/rc.pcscd.new

# For slackbuilds.org, assigned pcscd uid/gid are 257/257
# See http://slackbuilds.org/uid_gid.txt
# Add user and group
if ! grep -q "^pcscd:" /etc/group 2>&1 > /dev/null; then
    if ! grep -q ":257:" etc/group; then
        chroot . groupadd -g 257 pcscd &>/dev/null
    else
        chroot . groupadd pcscd &>/dev/null
    fi
fi

if ! grep -q "^pcscd:" etc/passwd; then
    if ! grep -q ":257:" etc/passwd; then
        chroot . useradd -u 257 -g pcscd -d /var/run/pcscd -s /bin/false pcscd &> /dev/null
    else
        chroot . useradd -g pcscd -d /var/run/pcscd -s /bin/false pcscd &> /dev/null
    fi
fi
