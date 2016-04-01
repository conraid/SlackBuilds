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

perms() {
  NEW="$1"
  OLD="$(dirname $NEW)/$(basename $NEW .new)"
  if [ -e $OLD ]; then
    cp -a $OLD ${NEW}.incoming
    cat $NEW > ${NEW}.incoming
    mv ${NEW}.incoming $NEW
  fi
  config $NEW
}

perms etc/rc.d/rc.postgresql.new
config etc/logrotate.d/postgresql.new

if ! grep -q "^postgres:" etc/group; then
  if ! grep -q ":209:" etc/group; then
    chroot . groupadd -g 209 postgres &>/dev/null
  else
    chroot . groupadd postgres &>/dev/null
  fi
fi
if ! grep -q "^postgres:" etc/passwd; then
  if ! grep -q ":209:" etc/passwd; then
    chroot . useradd -u 209 -d /var/lib/pgsql -g postgres postgres &>/dev/null
  else
    chroot . useradd -d /var/lib/pgsql -g postgres postgres &>/dev/null
  fi
fi

# Create default program symlinks in /usr/bin
(
  cd usr/bin
  for pg_binary in ../lib%LIBDIRSUFFIX%/postgresql/%PG_VERSION%/bin/*; do
    pg_prog=$(basename $pg_binary)
    if [ -L $pg_prog ]; then
      ln -sf $pg_binary
    elif [ ! -e $pg_prog ]; then
      # make sure we don't overwrite actual binaries
      ln -s $pg_binary
    fi
  done
)

cat << EOF
Before you can run postgresql you'll need to create the
database files in /var/lib/pgsql. The following should do
the trick.
 # su postgres -c "initdb -D /var/lib/pgsql/%PG_VERSION%/data --locale=en_US.UTF-8 -A md5 -W"

EOF

