#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

for loc in $@; do
  metadata=${loc}/metadata.json 
  echo "MetaData: $metadata"
  #continue
  jq '{            
    "RRID": .rrid,
    "Srcp": (.SRCRPMs | join(", ")),
    "Pkgr": .packager,
    "Pkgs": (.packages | to_entries | map(.value | map(split(" = ")[0]) | unique) | add | unique | join(", "))
  }' < ${metadata}
  echo;
done
