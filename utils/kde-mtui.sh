#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

TEMP_WINDOW='/Windows/1'
: ${KONSOLE_DBUS_WINDOW:=${TEMP_WINDOW}}

get_short_id () {
  id=$1
  id=$(echo $id | sed 's/SUSE:Maintenance/S:M/g');
  id=$(echo $id | sed -E 's|.*S:M:([0-9]{5,6}:[0-9]{6,7}).*|\1|g');
  id=$(echo $id | sed -E 's|:?([0-9]{5,6}:[0-9]{6,7}).*|\1|g');
  echo "S:M:${id}"
}

while [ $# -gt 0 ] ; do
  rr=$(get_short_id ${1})
  echo $rr

  session_num=$(qdbus-qt5 $KONSOLE_DBUS_SERVICE $KONSOLE_DBUS_WINDOW newSession)
  sleep 1
  qdbus-qt5  $KONSOLE_DBUS_SERVICE /Sessions/${session_num} runCommand "mtui -a $rr" > /dev/null
  qdbus-qt5  $KONSOLE_DBUS_SERVICE /Sessions/${session_num} setTitle 1 "$rr" > /dev/null
  shift
  sleep 1
done

