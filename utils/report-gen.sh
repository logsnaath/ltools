#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
# Usage: report-gen.sh reports

enrich_report () {
  id=$1
  id=$(echo $id | sed 's/SUSE:Maintenance/S:M/g');
  id=$(echo $id | sed -E 's|.*S:M:([0-9]{5,6}:[0-9]{6,7}).*|\1|g');
  id=$(echo $id | sed -E 's|:?([0-9]{5,6}:[0-9]{6,7}).*|\1|g');

  echo "ID: $id" >&2
  incident=$(echo $id | cut -d: -f1)
  request=$(echo $id | cut -d: -f2)
  #return

  update_data="$(osc --apiurl https://api.suse.de qam info SUSE:Maintenance:${incident}:${request})"
  prod=$(echo "$update_data" | awk -F': ' '/SRCRPMs/{print $2}')
  prio=$(echo "$update_data" | awk -F': ' '/Incident Priority/{print $2}')

  echo -n "<li><font color=\"#212529\">S:M:</font><a href=\"https://smelt.suse.de/incident/${incident}/\">${incident}</a>"
  echo    "<font color=\"#212529\">:<a href=\"https://smelt.suse.de/request/${request}/\">${request}</a> - "
  echo    "<font color=\"#212529\"><a href=\"https://smelt.suse.de/maintained?q=${prod}\">${prod}</a> / "
  echo    "<a userkey=\"ff80808187dae5ea0187dbfaafb40001\" data-linked-resource-default-alias=\"Logu R\" class=\"confluence-link confluence-userlink user-mention current-user-mention\" data-username=\"lrangasamy\" data-linked-resource-version=\"2\" data-linked-resource-type=\"userinfo\" href=\"/display/~lrangasamy\" data-base-url=\"https://confluence.suse.com\">Logu R</a>"
 
}

rm_file () {
  echo "Removing file $1"
  rm -f $1
}

IDS=$@
if [ -z "$IDS" ]; then
  echo "Usage: $(basename $0) XXXXX:XXXXXX | *S:M:XXXXX:XXXXXX* | *SUSE:Maintenace:XXXXX:XXXXXX*"
  exit;
fi

fname="/tmp/rp_$(date +'%Y_%m_%H%M%S').html"
trap 'rm_file $fname' 0
echo '&nbsp; <br>'  >> $fname
for i in $IDS; do
  echo; echo "==> Processing $i"
  enrich_report $i | tee -a  $fname
done

#libreoffice --writer $fname 
for cmd in google-chrome firefox; do
  if command -v $cmd; then
    $cmd $fname
    break
  fi
done
sleep 5;
