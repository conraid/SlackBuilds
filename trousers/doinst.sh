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
config etc/tcsd.conf.new

# Add user and group (uid and gid are SBo suggests)
if ! grep -q "^tss:" etc/group; then
    if ! grep -q ":374:" etc/group; then
        chroot . groupadd -g 374 tss &>/dev/null
    else
        chroot . groupadd tss &>/dev/null
    fi
fi

if ! grep -q "^tss:" etc/passwd; then
    if ! grep -q ":374:" etc/passwd; then
        chroot . useradd -u 374 -d /dev/null -s /bin/false -c "TSS" -g tss tss &>/dev/null
    else
        chroot . useradd -d /dev/null -s /bin/false -c "TSS" -g tss  tss &>/dev/null
    fi
fi
