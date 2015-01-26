config() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  # If there's no config file by that name, mv it over:
  if [ ! -r $OLD ]; then
    mv $NEW $OLD
  elif [ "$(cat $OLD | md5sum)" = "$(cat $NEW | md5sum)" ]; then # toss the redundant copy
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

# If there's no existing log file, move this one over; 
# otherwise, kill the new one
if [ ! -e var/log/privoxy/logfile ]; then
  mv var/log/privoxy/logfile.new var/log/privoxy/logfile
else
  rm -f var/log/privoxy/logfile.new
fi

# Bail if user isn't valid on your system
if ! grep -q "^privoxy:" etc/group ; then
    if ! grep -q ":206:" etc/group ; then
        chroot . groupadd -g 206 privoxy &>/dev/null
    else
        chroot . groupadd privoxy &>/dev/null
    fi
fi

if ! grep -q "^privoxy:" etc/passwd ; then
    if ! grep -q ":206:" etc/passwd ; then
        chroot . useradd -d /dev/null -s /bin/false -c "Web Proxy" -u 206 -g privoxy privoxy &>/dev/null
    else
        chroot . useradd -d /dev/null -s /bin/false -c "Web Proxy" -g privoxy privoxy &>/dev/null
    fi
fi

perms etc/rc.d/rc.privoxy.new
config etc/privoxy/config.new
config etc/privoxy/match-all.action.new
config etc/privoxy/trust.new
config etc/privoxy/user.action.new
config etc/privoxy/user.filter.new
