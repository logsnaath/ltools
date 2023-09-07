#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

if [ -z "$1" ]; then
  echo 'Hostname/IP is required'
  exit 1
fi

do_repose() {
  refhost=$1
  echo $refhost;

  ssh-copy-id root@$refhost
  repose reset   -t $refhost
  repose install -t $refhost qa
  repose install -t $refhost sle-module-basesystem sle-module-containers sle-module-desktop-applications sle-module-legacy sle-module-live-patching sle-module-public-cloud sle-module-server-applications sle-module-web-scripting
}

do_repose $1
