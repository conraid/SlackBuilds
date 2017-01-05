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

config etc/default/ufw.new
config etc/ufw/ufw.conf.new
config etc/ufw/sysctl.conf.new


