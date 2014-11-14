#!/bin/sh

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

# Keep same perms on rc.postfix.new:
if [ -e etc/rc.d/rc.postfix ]; then
  cp -a etc/rc.d/rc.postfix etc/rc.d/rc.postfix.new.incoming
  cat etc/rc.d/rc.postfix.new > etc/rc.d/rc.postfix.new.incoming
  mv etc/rc.d/rc.postfix.new.incoming etc/rc.d/rc.postfix.new
else 
  chmod 0755 etc/rc.d/rc.postfix.new
fi

config etc/postfix/access.new
config etc/postfix/aliases.new
config etc/postfix/canonical.new
config etc/postfix/generic.new
config etc/postfix/header_checks.new
config etc/postfix/main.cf.new
config etc/postfix/makedefs.out.new
config etc/postfix/master.cf.new
config etc/postfix/relocated.new
config etc/postfix/transport.new
config etc/postfix/virtual.new
config etc/rc.d/rc.postfix.new

# Add user and group
if ! grep -q "^postfix:" etc/group; then
    if ! grep -q ":200:" etc/group; then
	chroot . groupadd -g 200 postfix &>/dev/null
    else
	chroot . groupadd postfix &>/dev/null
    fi
fi

if ! grep -q "^postfix:" etc/passwd; then
    if ! grep -q ":200:" etc/passwd; then
	chroot . useradd -u 200 -d /dev/null -s /bin/false -c "Postfix" -g postfix postfix &>/dev/null
    else
	chroot . useradd -d /dev/null -s /bin/false -c "Postfix" -g postfix postfix &>/dev/null
    fi
fi

if ! grep -q "^postdrop:" etc/group; then
    if ! grep -q ":201:" etc/group; then
	chroot . groupadd -g 201 postdrop &>/dev/null
    else
	chroot . groupadd postdrop &>/dev/null
    fi
fi

# This is an incompatability with the sendmail package
( cd usr/lib; ln -sf /usr/sbin/sendmail sendmail)

postfix set-permissions

# This will set the permissions on all postfix files correctly
echo ""
echo "######## IMPORTANT ##########"
echo ""
echo "Set the permissions on all files correctly with command:"
echo "# postfix set-permissions"
echo ""
echo "Check new config files with deprecated parameters"
echo ""
echo "#############################"
echo ""

