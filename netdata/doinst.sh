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
    mv $NEW.incoming $NEnetdataW
  fi
  config $NEW
}

perms etc/rc.d/rc.netdata.new
for NEW in $(find etc/netdata/ -name "*.new"); do
  config $NEW
done

for NEW in $(find usr/lib/netdata -name "*.new"); do
  config $NEW
done

# Add user and group
# (338 uid and gid are SBo suggests https://slackbuilds.org/uid_gid.txt)
if ! grep -q "^netdata:" etc/group; then
  if ! grep -q ":338:" etc/group; then
    chroot . groupadd -g 338 netdata &>/dev/null
  else
    chroot . groupadd netdata &>/dev/null
  fi
fi

if ! grep -q "^netdata:" etc/passwd; then
  if ! grep -q ":338:" etc/passwd; then
    chroot . useradd -u 338 -d /var/cache/netdata -s /bin/false -g netdata netdata &>/dev/null
  else
    chroot . useradd -d /var/cache/netdata -s /bin/false -g netdata netdata &>/dev/null
  fi
fi

if [ -x /usr/libexec/netdata/plugins.d/apps.plugin ] ; then
setcap cap_dac_read_search,cap_sys_ptrace+ep "usr/libexec/netdata/plugins.d/apps.plugin"
fi
if [ -x /usr/libexec/netdata/plugins.d/debugfs.plugin ] ; then
setcap cap_dac_read_search+ep "usr/libexec/netdata/plugins.d/debugfs.plugin"
fi
if [ -x /usr/libexec/netdata/plugins.d/go.d.plugin ] ; then
setcap cap_dac_read_search,cap_net_admin,cap_net_raw+eip "usr/libexec/netdata/plugins.d/go.d.plugin"
fi
if [ -x /usr/libexec/netdata/plugins.d/logs-management.plugin ] ; then
setcap cap_dac_read_search,cap_syslog+ep "usr/libexec/netdata/plugins.d/logs-management.plugin"
fi
if [ -x /usr/libexec/netdata/plugins.d/network-viewer.plugin ] ; then
setcap cap_sys_admin,cap_sys_ptrace,cap_dac_read_search+ep "usr/libexec/netdata/plugins.d/network-viewer.plugin"
fi
if [ -x /usr/libexec/netdata/plugins.d/perd.plugin ] ; then
setcap cap_perfmon,cap_sys_admin+ep "usr/libexec/netdata/plugins.d/perf.plugin"
fi
if [ -x /usr/libexec/netdata/plugins.d/slabinfo.plugin ] ; then
setcap cap_dac_read_search+ep "usr/libexec/netdata/plugins.d/slabinfo.plugin"
fi
