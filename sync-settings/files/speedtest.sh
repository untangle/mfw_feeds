#!/bin/sh

# ./speedtest.sh interface

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

disable_qos $interface
RESULT=$(/usr/bin/speedtest-cli --simple-json --source $ip_address 2>/dev/null)
if [ $? -ne 0 ] ; then
	RESULT="{}"
fi
enable_qos $interface
echo $RESULT
