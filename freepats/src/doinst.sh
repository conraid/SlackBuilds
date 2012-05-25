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

config etc/timidity/crude.cfg.new
config etc/timidity/freepats.cfg.new

echo ""
echo " To use freepats with TiMidity++ and/or SDL_mixer, edit"
echo "  /etc/timidity.cfg and make it look like this:"
echo "  source /etc/timidity/freepats.cfg"
echo ""