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

for NEW in etc/mopidy/*.new; do
    config $NEW
done

if [ -x /usr/bin/update-desktop-database ]; then
    /usr/bin/update-desktop-database -q usr/share/applications >/dev/null 2>&1
fi

if [ -e usr/share/icons/hicolor/icon-theme.cache ]; then
    if [ -x /usr/bin/gtk-update-icon-cache ]; then
        /usr/bin/gtk-update-icon-cache -t -f -q usr/share/icons/hicolor >/dev/null 2>&1
    fi
fi

if ! grep -q "^mopidy:" etc/group; then
  chroot . groupadd -g 446 mopidy 2>/dev/null
fi

if ! grep -q "^mopidy:" etc/passwd; then
  chroot . useradd -u 446 -g mopidy -d /var/lib/mopidy -s /bin/false -c "Mopidy User" mopidy 2>/dev/null
fi

if grep -q "^audio:" etc/group; then
  chroot . usermod -a -G audio mopidy 2>/dev/null
fi

