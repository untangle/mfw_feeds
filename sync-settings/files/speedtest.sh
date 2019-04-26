#!/bin/sh

# ./speedtest.sh interface

# get the speedtest server list from:
# c.speedtest.net/speedtest-servers-static.php
SERVERS="speedtest.sjc.sonic.net phx.speedtest.net speedtest.mikrotec.com speedtest.fhsu.edu speedtest.rit.edu"

get_ipv4_address() {
	intf=$1
	ifconfig $intf | awk '/inet addr/{print substr($2,6)}' | head -n1
}

get_ipv6_address() {
	intf=$1
	ifconfig $intf | grep Global | awk '/inet6 addr/{print substr($3,1)}' | cut -d '/' -f 1 | head -n1
}

get_ip_address() {
	intf=$1
	ip_address=$(get_ipv4_address $intf)

	if [ -z $ip_address ] ; then
		ip_address=$(get_ipv6_address $intf)
	fi


	echo $ip_address
}

get_tx_bytes() {
	intf=$1
	cat /proc/net/dev | grep $intf: | grep -v ifb | awk '{print $10}'
}

get_rx_bytes() {
	intf=$1
	cat /proc/net/dev | grep $intf: | grep -v ifb | awk '{print $2}'
}

get_timestamp() {
	read up rest </proc/uptime; ts="${up%.*}${up#*.}"
	echo $ts
}

run_test() {
	local __result=$1
	direction=$2
	intf=$3
	ip_addr=$4

	for SERVER in $SERVERS
	do
		if [ "$direction" = "download" ] ; then
			SPEEDTEST_URL="http://$SERVER/speedtest/random3500x3500.jpg"
			wget --bind-address $ip_addr -q --timeout=60 -O /dev/null $SPEEDTEST_URL &
		else
			SPEEDTEST_URL="http://$SERVER/speedtest/upload.php"
			wget --bind-address $ip_addr -q --timeout=60 --body-file=/tmp/5MB.zip --method=put -O /dev/null $SPEEDTEST_URL &
		fi
	done

	if [ "$direction" = "download" ] ; then
		before_bytes=$(get_rx_bytes $intf)
	else
		before_bytes=$(get_tx_bytes $intf)
	fi

	before=$(get_timestamp)
	sleep 10

	if [ "$direction" = "download" ] ; then
		after_bytes=$(get_rx_bytes $intf)
	else
		after_bytes=$(get_tx_bytes $intf)
	fi
	after=$(get_timestamp)

	for i in `pgrep -P $$ `
	do
		wait $i
	done

	delta=$((10*(after - before)))
	delta_bytes=$((after_bytes - before_bytes))
	speed=$((delta_bytes / delta))
	speed=$((speed * 8))
	eval $__result="$speed"
}

run_ping_test() {
	ip_addr=$1

	SPEEDTEST_ADDRESS="speedtest.mikrotec.com"
	case "$ip_addr" in
	*:*)
		ping6 -I $ip_addr -q -c 5 $SPEEDTEST_ADDRESS | grep round | cut -d '/' -f 4 | cut -d '.' -f 1
		;;
	*)
		ping -I $ip_addr -q -c 5 $SPEEDTEST_ADDRESS | grep round | cut -d '/' -f 4 | cut -d '.' -f 1
		;;
	esac
}

disable_qos() {
	intf=$1

	if [ -f /etc/config/qos.d/10-disable-qos-wan-$intf ] ; then
		/etc/config/qos.d/10-disable-qos-wan-$intf
	fi
}

enable_qos() {
	intf=$1

	if [ -f /etc/config/qos.d/20-enable-qos-wan-$intf ] ; then
		/etc/config/qos.d/20-enable-qos-wan-$intf
	fi
}

interface=$1
if [ -z $interface ] ; then
	echo "No interface specified"
	exit 1
fi

ip_address=$(get_ip_address $interface)
if [ -z $ip_address ] ; then
	echo "$interface has no ip address"
	exit 1
fi

ping_result=$(run_ping_test $ip_address)
if [ -z $ping_result ] ; then
	echo "Cannot ping $SPEEDTEST_URL"
	exit 1
fi

disable_qos $interface
run_test dl_result "download" $interface $ip_address
dd if=/dev/zero of=/tmp/5MB.zip bs=1M count=5 2> /dev/null
run_test ul_result "upload" $interface $ip_address
enable_qos $interface
rm /tmp/5MB.zip
echo "{\"ping\":$ping_result,\"download\":$dl_result,\"upload\":$ul_result}"
