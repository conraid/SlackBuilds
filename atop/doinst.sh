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

perms etc/rc.d/rc.atop.new
perms etc/rc.d/rc.atopacct.new
config etc/cron.daily/atop.new
config etc/logrotate.d/psacct.new
config etc/logrotate.d/psaccs_atop.new
config etc/logrotate.d/psaccu_atop.new
config etc/default/atop.new

touch var/log/atop/daily.log

