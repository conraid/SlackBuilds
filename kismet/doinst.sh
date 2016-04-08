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

for NEW in etc/kismet/*.new; do
  config $NEW
done

# Add user and group
if ! grep -q "^kismet:" etc/group; then
    if ! grep -q ":234:" etc/group; then
	chroot . groupadd -g 234 kismet &>/dev/null
    else
	chroot . groupadd kismet &>/dev/null
    fi
fi

