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

# Keep same perms on rc.postgresql.new:
if [ -e etc/rc.d/rc.postgresql ]; then
  cp -a etc/rc.d/rc.postgresql etc/rc.d/rc.postgresql.new.incoming
  cat etc/rc.d/rc.postgresql.new > etc/rc.d/rc.postgresql.new.incoming
  mv etc/rc.d/rc.postgresql.new.incoming etc/rc.d/rc.postgresql.new
fi

config etc/rc.d/rc.postgresql.new
config etc/logrotate.d/postgresql.new

# Add user and group
if ! grep -q "^postgres:" etc/group; then
    if ! grep -q ":209:" etc/group; then
	chroot . groupadd -g 209 postgres &>/dev/null
    else
	chroot . groupadd postgres &>/dev/null
    fi
fi

if ! grep -q "^postgres:" etc/passwd; then
    if ! grep -q ":209:" etc/passwd; then
	chroot . useradd -u 209 -d /var/lib/pgsql -c "PostgreSQL" -g postgres postgres &>/dev/null
    else
	chroot . useradd -d /var/lib/pgsql -c "PostgreSQL" -g postgres postgres &>/dev/null
    fi
fi

# base database directory
# assumes you are using /var/lib/pgsql as a homedir for postgres user
mkdir -p var/lib/pgsql/data
chown -R postgres:postgres var/lib/pgsql
chmod 700 var/lib/pgsql
# permissions for DATADIR should be u=rwx (0700)
chmod 700 var/lib/pgsql/data
