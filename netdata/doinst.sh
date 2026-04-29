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
		cat $NEW >$NEW.incoming
		mv $NEW.incoming $NEW
	fi
	config $NEW
}

perms etc/rc.d/rc.netdata.new
for NEW in $(find etc/netdata var/lib/netdata usr/lib*/netdata -name "*.new" 2>/dev/null); do
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

apply_caps() {
	local FILE="usr/libexec/netdata/plugins.d/$1"
	shift
	local CAPS_LIST="$@"

	if [ -x "$FILE" ]; then
		for CAP in $CAPS_LIST; do
			# Proviamo ad applicare la capability singolarmente
			setcap "${CAP}+ep" "$FILE" 2>/dev/null
		done
	fi
}

apply_caps "ebpf.plugin" cap_sys_admin cap_sys_ptrace cap_dac_read_search cap_perfmon

apply_caps "apps.plugin" cap_dac_read_search cap_sys_ptrace

apply_caps "freeipmi.plugin" cap_sys_rawio

apply_caps "network-viewer.plugin" cap_sys_admin cap_sys_ptrace cap_dac_read_search
apply_caps "go.d.plugin" cap_net_admin cap_net_raw
apply_caps "nfacct.plugin" cap_net_admin

apply_caps "debugfs.plugin" cap_dac_read_search
apply_caps "perf.plugin" cap_perfmon cap_sys_admin
apply_caps "slabinfo.plugin" cap_dac_read_search
apply_caps "ioping.plugin" cap_net_raw

apply_caps "cups.plugin" cap_dac_override
