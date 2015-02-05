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

config etc/httpd/extra/modsecurity-recommended.conf.new
config etc/httpd/conf/crs/modsecurity_crs_10_setup.conf.new

echo ""
echo "=== NOTE : "
echo ""
echo "  You can get started with ModSecurity by adding the following lines to the"
echo "  appropriate sections of Apache's main configuration file (httpd.conf):"
echo ""
echo "    LoadModule security2_module lib%LIBSUFFIX%/httpd/modules/mod_security2.so"
echo "    <IfModule security2_module>"
echo "    Include /etc/httpd/extra/modsecurity-recommended.conf"
echo "    </IfModule>"
echo ""
echo "==="
echo ""
