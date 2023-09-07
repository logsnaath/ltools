#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

#sudo cp /etc/resolv.conf_bk /etc/resolv.conf

sudo openvpn \
  --config /etc/openvpn/SUSE-NUE.conf \
  --auth-user-pass ~logu/ovpn/auth.txt $@

