#!/bin/sh
#
export CMD_MATCH=$1
export FULL_CMD=$2
c_temp=$(nft list chain inet shaping quota-rules -a | grep "$CMD_MATCH")
c_tmp=${c_temp#*handle}
nft delete rule inet shaping quota-rules handle $c_tmp
$FULL_CMD
