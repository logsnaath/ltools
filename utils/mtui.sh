#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

get_short_id () {
  id=$1
  id=$(echo $id | sed 's/SUSE:Maintenance/S:M/g');
  id=$(echo $id | sed -E 's|.*S:M:([0-9]{5,6}:[0-9]{6,7}).*|\1|g');
  id=$(echo $id | sed -E 's|:?([0-9]{5,6}:[0-9]{6,7}).*|\1|g');
  echo "S:M:${id}"
}

rr=$(get_short_id ${1})
echo $rr

qdbus-qt5  $KONSOLE_DBUS_SERVICE $KONSOLE_DBUS_SESSION runCommand "mtui -a $rr" > /dev/null
qdbus-qt5  $KONSOLE_DBUS_SERVICE $KONSOLE_DBUS_SESSION setTitle 1 "$rr" > /dev/null

