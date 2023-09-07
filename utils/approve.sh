#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
# Usage: approve.sh reports
#

exp_sm() {
  #echo $@
  ## Expand S:M
  cmd=$(echo $@|sed -e 's|ibs \+qam|osc --apiurl https://api.suse.de qam|g' \
                      -e 's|S:M|SUSE:Maintenance|g')
  echo $cmd
  $cmd
}
qam='exp_sm ibs qam'

get_rr () {
  id=$1
  id=$(echo $id | sed 's/SUSE:Maintenance/S:M/g');
  id=$(echo $id | sed -E 's|.*S:M:([0-9]{5,6}:[0-9]{6,7}).*|\1|g');
  id=$(echo $id | sed -E 's|:?([0-9]{5,6}:[0-9]{6,7}).*|\1|g');
  if [ -z "$id" ]; then
    return
  fi

  echo "ID: $id" >&2
  incident=$(echo $id | cut -d: -f1)
  request=$(echo $id | cut -d: -f2)
  #return
  echo "SUSE:Maintenance:${incident}:${request}"
}

#new_reviewer="$(echo $1|sed 's/^[ \t]*//;s/[ \t]*$//')"; shift
IDS=$@
if [ -z "$IDS" ]; then
  echo "Usage: $(basename $0) \"Reviewer\" XXXXX:XXXXXX | *S:M:XXXXX:XXXXXX* | *SUSE:Maintenace:XXXXX:XXXXXX*"
  exit;
fi
#echo "==> IDs: $IDS"
echo;

for i in $IDS; do
  echo "==> Processing $i"
  rr=$(get_rr $i)
  tmpl_dir="$HOME/qam/$rr"
  report="$tmpl_dir/log"

  echo;
  cur_reviewer=$(grep "Test Plan Reviewer:" $report | awk -F 'Test Plan Reviewer:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
  echo "--> Current   Reviewer: $cur_reviewer"
  if [ "$cur_reviewer" != "#team-lsg-qe-maintenance" ]; then
    echo -n "Do you want to approve this review: $rr? y/n[n] "
    read inp;
    if [ "${inp}" = 'y' ] || [ "${inp}" = 'Y' ]; then 
      #echo "Commiting .. $(cd $tmpl_dir; svn commit -m '')"
      echo "Approving .."
      $qam approve $rr
      echo;
    fi
  else
    echo "ERROR: Reviewer should be required "
  fi
  echo "-------------------------------------------"; echo
done
