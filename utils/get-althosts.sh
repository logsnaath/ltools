#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

hosts=$@

if [ -z "$hosts" ]; then
  echo "Usage: $(basename $0) bad_host1 [bad_host2 ...]"
  exit 1
fi

print_althost () {
  host=$1
  sstr=$(refdb -p arch,SLES name=$host | awk -F': ' '{print $2}'|head -n1)
  if [ -z "$sstr" ]; then
    echo "ERROR: Host not found in refdb"
    return
  fi
  echo "===> $sstr"
  refdb -p name, $sstr | awk -F': name=' '{print $2}'| uniq | grep --color=always -E "$host"'|$'
}

for h in $hosts; do
  print_althost $h
  echo;
done
