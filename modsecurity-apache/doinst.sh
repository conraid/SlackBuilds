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

config etc/httpd/mod_security3.conf.new
config etc/httpd/modsecurity.d/crs/crs-setup.conf.new
config etc/httpd/modsecurity.d/include.conf.new
config etc/httpd/modsecurity.d/modsecurity.conf.new

echo ""
echo "=== NOTE : "
echo ""
echo "  You can get started with ModSecurity by adding the following lines to the"
echo "  appropriate sections of Apache's main configuration file (httpd.conf):"
echo ""
echo "    Include /etc/httpd/mod_security3.conf"
echo ""
echo "==="
echo ""
