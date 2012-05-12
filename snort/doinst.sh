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

perm etc/rc.d/rc.snort.new
config etc/rc.d/rc.snort.new
config etc/snort/snort.conf.new
config etc/snort/reference.config.new
config etc/snort/threshold.conf.new
config etc/snort/attribute_table.dtd.new
config etc/snort/classification.config.new
config etc/snort/gen-msg.map.new
config etc/snort/unicode.map.new

