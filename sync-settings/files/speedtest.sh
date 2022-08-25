#!/bin/sh

# MFW-1606 Added --no-pre-allocate argument when calling speedtest-cli as it
# often fails to allocate memory during the upload test, especially on
# limited hardware. Improved error detection and handling.
# Our version of speedtest-cli on success returns a result in this format:
# {"ping":12,"download":,12345,"upload":1234}
# On failure we can't simply return {} because the user interface will
# throw an error since the expected key/value pairs are missing.
# So now we return {"error":"message"} if something goes wrong so the
# UI can detect and display the error message, otherwise we'll return
# the JSON result we get from the utility.

# USAGE: ./speedtest.sh interface

get_ipv4_address() {
	intf=$1
	ifconfig $intf 2>/dev/null | awk '/inet addr/{print substr($2,6)}' | head -n1
}

get_ipv6_address() {
	intf=$1
	ifconfig $intf 2>/dev/null | grep Global | awk '/inet6 addr/{print substr($3,1)}' | cut -d '/' -f 1 | head -n1
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
    echo "{\"error\":\"No interface specified\"}"
	exit 1
fi

ip_address=$(get_ip_address $interface)
if [ -z $ip_address ] ; then
    echo "{\"error\":\"Interface has no IP address\"}"
	exit 1
fi

disable_qos $interface
OUTPUT=$(/usr/bin/speedtest-cli --secure --simple-json --no-pre-allocate --source $ip_address 2>&1)
if [ $? -ne 0 ] ; then
	RESULT="{\"error\":\"$OUTPUT\"}"
else
    RESULT=$OUTPUT
fi
enable_qos $interface
echo $RESULT
