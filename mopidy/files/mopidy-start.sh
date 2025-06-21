#!/bin/bash

MOPIDY_BIN=/usr/bin/mopidy
MOPIDY_CONF=$HOME/.config/mopidy/mopidy.conf
PIDFILE=$HOME/.mopidy.pid
LOGFILE=$HOME/.mopidy.log

start() {
    if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
        echo "Mopidy is already running."
        exit 1
    fi
    nohup "$MOPIDY_BIN" --config "$MOPIDY_CONF" > "$LOGFILE" 2>&1 &
    echo $! > "$PIDFILE"
    echo "Mopidy started."
}

stop() {
    if [ ! -f "$PIDFILE" ]; then
        echo "Mopidy not running."
        exit 1
    fi
    kill "$(cat "$PIDFILE")" && rm -f "$PIDFILE"
    echo "Mopidy stopped."
}

status() {
    if [ -f "$PIDFILE" ] && kill -0 "$(cat "$PIDFILE")" 2>/dev/null; then
        echo "Mopidy is running (PID $(cat "$PIDFILE"))"
    else
        echo "Mopidy is stopped."
        exit 1
    fi
}

case "$1" in
    start) start ;;
    stop) stop ;;
    restart) stop; start ;;
    status) status ;;
    *) echo "Usage: $0 {start|stop|restart|status}" ;;
esac

