#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

[ -z "$1" ] && echo "Nothing to assign"
for update in $@; do
  update=$(echo $update | sed -e 's|S:M|SUSE:Maintenance|g')
  osc --apiurl https://api.suse.de qam assign $update;
done
