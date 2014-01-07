#!/bin/sh

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

perm etc/rc.d/rc.sshguard.new
config etc/rc.d/rc.sshguard.new
config etc/sshguard/whitelist.new
config etc/sshguard/sshguard.conf.new

echo ''
echo "-- You should add chain to your firewall:"
echo "--   iptables -N sshguard"
echo "--   iptables -A INPUT -j sshguard"
echo "-- For more information, see http://www.sshguard.net/docs/"
echo ''

