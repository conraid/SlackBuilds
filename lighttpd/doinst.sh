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

perms etc/rc.d/rc.lighttpd.new
config etc/logrotate.d/lighttpd.new
config etc/lighttpd/lighttpd.conf.new
config etc/lighttpd/modules.conf.new
config etc/lighttpd/vhosts.d/vhosts.conf.new
for NEW in etc/lighttpd/conf.d/*.new; do
  config $NEW
done


# Create dummy logfiles, but throw them away if logfiles are already here:
for i in access error ; do
  if [ -e var/log/lighttpd/${i}.log ]; then
    rm -f var/log/lighttpd/${i}.log.new
  else
    mv var/log/lighttpd/${i}.log.new var/log/lighttpd/${i}.log
  fi
done

# Add user and group (usually uid and gid are SBo suggests)
if ! grep -q "^lighttpd:" etc/group; then
    if ! grep -q ":208:" etc/group; then
        chroot . groupadd -g 208 lighttpd &>/dev/null
    else
        chroot . groupadd lighttpd &>/dev/null
    fi
fi

if ! grep -q "^lighttpd:" etc/passwd; then
    if ! grep -q ":208:" etc/passwd; then
        chroot . useradd -u 208 -d /var/www -g lighttpd lighttpd &>/dev/null
    else
        chroot . useradd -d /var/wwww -g lighttpd lighttpd &>/dev/null
    fi
fi

chroot . gpasswd -a lighttpd apache
