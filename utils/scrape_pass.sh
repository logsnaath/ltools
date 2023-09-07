#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

#for l in `cat links.txt | grep x86_64`; do
#  curl -ks $l | grep '=' | grep ' passed'
#done
#

for l in `ls build_checks/* | grep "$1"`; do
  echo "$l:"| sed 's|build_checks/||g'
  cat $l | grep -E '=\s+[0-9]+ passed| Ran |\] OK'
  #echo;
done

