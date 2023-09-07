#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

if [ -z "$NODES" ]; then
  echo "NODES env variable not set"
  exit 0
fi

echo "NODES: $NODES";

for h in $NODES; do
  echo "Running on: $h ==> $@"
  ssh -l root $h $@
  echo "--------------"
  echo;
done

