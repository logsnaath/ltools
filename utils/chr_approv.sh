#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
# Usage: chr_approv.sh "reviewer" "report1 report2"
#

if [ "$#" -ne 2 ]; then
  echo "Usage: $(basename $0) \"Reviewer\" \"report1 report2 ...\""
  exit 1
fi

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

check_report() {
  local id=$1
  echo "==> Processing $id"
  rr=$(get_rr $id)
  tmpl_dir="$HOME/qam/$rr"
  report="$tmpl_dir/log"

  if ! [ -f "$report" ]; then
     echo "ERROR: File $report NOT found. Skipping ..."
     return
  fi
  cur_reviewer=$(grep "Test Plan Reviewer:" $report | awk -F 'Test Plan Reviewer:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
  echo "--> Current   Reviewer: $cur_reviewer"
  echo;
}

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

change_reviewer() {
  for i in $IDS; do
    check_report $i
    if [ "$cur_reviewer" != "$new_reviewer" ]; then
      echo "--> Proposed  Reviewer: $new_reviewer"

      ## actual modification
      sed -i 's/Test Plan Reviewer: '"${cur_reviewer}"'/Test Plan Reviewer: '"${new_reviewer}"'/g' $report
      echo;
      changed_reviewer=$(grep "Test Plan Reviewer:" $report | awk -F 'Test Plan Reviewer:' '{print $2}' | sed 's/^[ \t]*//;s/[ \t]*$//')
      echo "--> Before change: $cur_reviewer"
      echo "--> After  change: $changed_reviewer"
    else
      echo "*** NO reviewer change required ***"
    fi
    if [ -n "$(cd $tmpl_dir; svn status -q)" ]; then
      echo
      echo "Commiting .. $(cd $tmpl_dir; svn commit -m '')"
    else
      echo "No changes made since last commit"
    fi
    echo "-------------------------------------------"; echo
  done
  echo "==========================================="
}

approve_report() {
  for i in $IDS; do
    check_report $i
    #set -x
    if [ -n "$cur_reviewer" ] && [ "$cur_reviewer" != "#team-lsg-qe-maintenance" ]; then
      echo -n "Approve this review?: $rr? a[ll]/y[es]/n[o] [n]: "
      if [ "${inp}" != 'a' ] && [ "${inp}" != 'A' ]; then
        read -r inp;
      fi
      inp=$(echo "${inp}" | tr '[:lower:]' '[:upper:]')
      if [ "${inp}" = 'Y' ] || [ "${inp}" = 'A' ]; then
        #echo "Commiting .. $(cd $tmpl_dir; svn commit -m '')"
        echo "Approving .."
        ## actual modification
        $qam approve $rr
      fi
    else
      echo "ERROR: Reviewer should be changed"
    fi
    echo "-------------------------------------------"; echo
  done
}

generate_report(){
  fname="/tmp/rp_$(date +'%Y_%m_%H%M%S').html"
  trap 'rm_file $fname' 0
  echo '&nbsp; <br>'  >> $fname
  for i in $IDS; do
    check_report $i
    echo "==> Processing $i"
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
}

continue_to() {
  mesg=$1
  read -p "Continue ${mesg}? y/n[n] " inp;
  if [ "${inp}" = 'y' ] || [ "${inp}" = 'Y' ]; then
    echo "$mesg ..."
  else
    echo "NOT $mesg"
    return 1
  fi
  echo;
  return 0
}

## Remove leading and trailing spaces in the name
new_reviewer="$(echo $1|sed 's/^[ \t]*//;s/[ \t]*$//')"; shift
IDS=$@
if [ -z "$IDS" ] || echo $IDS | grep -qvE '[0-9]{5}:[0-9]{6}'; then
  echo "Usage: $(basename $0) \"Reviewer\" \"XXXXX:XXXXXX | *S:M:XXXXX:XXXXXX* | *SUSE:Maintenace:XXXXX:XXXXXX* ...\""
  exit;
fi
#echo "==> IDs: $IDS"
echo;
echo "==> Proposed NEW Reviewer for all: $new_reviewer"

if continue_to "Changing reviewer"; then
  change_reviewer;
else
  exit
fi

if continue_to "Approving report"; then
  approve_report;
fi

if continue_to "Generating report"; then
  generate_report;
fi



