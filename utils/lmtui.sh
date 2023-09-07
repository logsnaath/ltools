#!/bin/bash
#
# Author: Loganathan R <logu.rangasamy@suse.com>
#

echo -ne "\u001b]30;${1} \a" 0 > /dev/null
trap 'echo -ne "\u001b]30;${PWD}: $(basename ${SHELL}) \a"' 0 > /dev/null
mtui -a ${1};

#echo -ne "\033]30;LLLLLL\007"
#trap 'echo -ne "\033]30;${PWD}: (${BASH_COMMAND})\007"' DEBUG
#trap 'echo -ne "\u001b]30; TITLE \a"' DEBUG
#export PROMPT_COMMAND='echo -ne "\033]30;$PWD\007"'
