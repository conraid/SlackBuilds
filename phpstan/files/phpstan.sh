#!/bin/sh

CONFIG="$HOME/.config/phpstan/phpstan.neon"

if [ -f "$CONFIG" ]; then
    exec php /usr/share/php/phpstan/phpstan.phar \
        --configuration="$CONFIG" "$@"
else
    exec php /usr/share/php/phpstan/phpstan.phar "$@"
fi
