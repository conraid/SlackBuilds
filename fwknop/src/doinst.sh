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

perm() {
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

perm etc/rc.d/rc.fwknopd.new
config etc/fwknop/fwknopd.conf.new
config etc/fwknop/access.conf.new

echo "#"
echo "# ****** IMPORTANT ******"
echo "# fwknop-2.5"
echo "#"
echo "# If you are upgrading from an older version of fwknop,"
echo "# you will want to read the \"Backwards Compatibility\" section of"
echo "# the fwknop tutorial available here:"
echo "#"
echo "# cipherdyne.org/fwknop/docs/fwknop-tutorial.html#backwards-compatibility"
echo "#"
