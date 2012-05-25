perm() {
    # Keep same perms on file
    NEW="$1"
    OLD="$(dirname $NEW)/$(basename $NEW .new)"
    if [ -e $OLD ]; then
	cp -a $OLD $NEW.incoming
	cat $NEW > $NEW.incoming
	mv $NEW.incoming $NEW
    else 
	chmod 0755 $NEW
    fi
}

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

if ! grep -q "^ntop:" /etc/group; then
  echo "Adding Ntop group"
  groupadd -g 212 ntop &>/dev/null
fi

if ! grep -q "^ntop:" /etc/passwd; then
  echo "Adding Ntop user"
  useradd -g ntop -u 212 -d /var/ntop -c "Network Top User" -s /bin/false ntop &>/dev/null
fi

echo "Setting correct permissions"
chown -R ntop:ntop /var/lib/ntop
chown -R ntop:ntop /usr/share/ntop

perm  etc/rc.d/rc.ntop.new

for i in /etc/rc.d/rc.ntop.new /etc/ntop/*.new /etc/logrotate.d/ntop.new
do
	if [ -f $i ]
	then
		config $i
	fi
done

