#!/bin/sh

. /usr/share/libubox/jshn.sh

interface=$1
sim_info_path="/tmp/wwan_sim_info.$interface"

if [ -f $sim_info_path  ] ; then
	cat $sim_info_path
else
	echo {}
fi

