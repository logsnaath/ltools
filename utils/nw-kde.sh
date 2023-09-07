#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

if [ -z "$1" ]; then
   echo "Requires a command to be executed in a new tab/window"
   echo "Ex:"
   echo "$(basename $0) \"repose.sh node-name\""
   exit 1
fi
echo $@

TEMP_WINDOW='/Windows/1'
: ${KONSOLE_DBUS_WINDOW:=${TEMP_WINDOW}}

session_num=$(qdbus-qt5 $KONSOLE_DBUS_SERVICE $KONSOLE_DBUS_WINDOW newSession)
sleep 1

qdbus-qt5  $KONSOLE_DBUS_SERVICE /Sessions/${session_num} runCommand "$*" > /dev/null
qdbus-qt5  $KONSOLE_DBUS_SERVICE /Sessions/${session_num} setTitle 1 "$*" > /dev/null
sleep 1

