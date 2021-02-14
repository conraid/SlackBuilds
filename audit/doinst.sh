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


perms etc/rc.d/rc.auditd.new
for NEW in etc/audit/plugins.d/*.new; do
  config $NEW
done
config etc/audit/zos-remote.conf.new
config etc/audit/audisp-remote.conf.new
config etc/audit/audit-stop.rules.new
config etc/audit/auditd.conf.new
config etc/sysconfig/auditd
config etc/libaudit.conf.new
