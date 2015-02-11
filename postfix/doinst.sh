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

# Unset compatibility_level if UPGRADE
if [ -e etc/postfix/main.cf ]; then
	sed /^compatibility_level/"s/^/#/" -i etc/postfix/main.cf.new
	UPGRADE=ON
fi

perms etc/rc.d/rc.postfix.new
for NEW in etc/postfix/*.new; do
	config $NEW
done

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
( cd usr/lib; rm -f sendmail )
( cd usr/lib; ln -s /usr/sbin/sendmail sendmail)

# Set compatibility_level if UPGRADE
if [ -z $UPGRADE ]; then
	postfix set-permissions
else
	echo "
	*** NOTE ***
	Edit /etc/postfix/main.cf with new parameters and after
	run \"postfix set-permissions\" command.
	"
fi
