# Update the desktop database:
if [ -x /usr/bin/update-desktop-database ]; then
  /usr/bin/update-desktop-database -q usr/share/applications > /dev/null 2>&1
fi


# Copy sleuthkit JAR from /usr/share/java/
if [ -f /usr/share/java/sleuthkit-4.14.0.jar ]; then
  cp -f /usr/share/java/sleuthkit-*.jar /usr/share/autopsy/autopsy/modules/ext/
  echo "Sleuth Kit JAR files copied to Autopsy"
else
  echo ""
  echo "WARNING: Sleuth Kit not found!"
  echo "Install the 'sleuthkit' package and then run:"
  echo "  # cp -f /usr/share/java/sleuthkit-*.jar /usr/share/autopsy/autopsy/modules/ext/"
  echo ""
fi
