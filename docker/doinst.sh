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

perms etc/rc.d/rc.docker.new
config etc/default/docker.new
config etc/logrotate.d/docker.new

# Add user and group (uid and gid are SBo suggests)
if ! grep -q "^GROUPNAME:" etc/group; then
    if ! grep -q ":GROUPID:" etc/group; then
        chroot . groupadd -r -g 281 docker &>/dev/null
    else
        chroot . groupadd -r docker &>/dev/null
    fi
fi

echo "To use docker as a limited user, add your user to the 'docker' group"
echo "# usermod -a -G docker <your_username>"
