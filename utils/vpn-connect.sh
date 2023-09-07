#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

sudo openconnect us.vpn.suse.net \
	--user=lrangasamy@suse.com \
	--authgroup=suse.okta.com \
	--no-dtls
