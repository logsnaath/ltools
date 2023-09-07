#!/bin/bash
#
# Written by Paolo Stivanin <pstivanin@suse.com>
#
CMDS_TO_TEST=("lparstat" "ofpathname sda" "serv_config -l" "lsslot" "ls-vdev" "sys_ident -p" "sys_ident -s" "update_flash -s" "bootlist -m both -r" "drmgr -C" "nvram --partitions" "nvram --print-all-vpd")

for ((i = 0; i < ${#CMDS_TO_TEST[@]}; i++)); do
    cmd="$(echo "${CMDS_TO_TEST[$i]}")"
    echo "=================================="
    echo "Testing $cmd..."
    bash -c "$cmd"
    echo "=================================="
    echo
    echo
done

