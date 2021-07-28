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

config etc/owamp/owampd.conf.new
config etc/owamp/owampd.limits.new
perms etc/rc.d/rc.owampd.new

# Add user and group
if ! grep -q "^owamp:" etc/group; then
    if ! grep -q ":400:" etc/group; then
	chroot . groupadd -g 400 owamp &>/dev/null
    else
	chroot . groupadd owamp &>/dev/null
    fi
fi

if ! grep -q "^owamp:" etc/passwd; then
    if ! grep -q ":400:" etc/passwd; then
	chroot . useradd -u 400 -d /dev/null -s /bin/false -c "owamp" -g owamp owamp &>/dev/null
    else
	chroot . useradd -d /dev/null -s /bin/false -c "owamp" -g owamp owamp &>/dev/null
    fi
fi

chown owamp:owamp run/owamp

cat << EOF

  NOTE
  ----
  You will need to create an owampd.conf file in /etc/owamp/ before you can run
  owampd. See the owampd.conf(5) manual page and /etc/owamp/owampd.conf.sample
  file for details. You may also want to create owampd.limits(5) and
  owampd.pfs(5) files.

  The "OWAMP Cookbook", an overview of the OWAMP tool and an owampd server
  installation guide, is available under the LINKS section of the OWAMP web
  page:
  http://e2epi.internet2.edu/owamp/ 
  ----

EOF
