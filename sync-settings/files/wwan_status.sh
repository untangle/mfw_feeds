#!/bin/sh

. /usr/share/libubox/jshn.sh

interface=$1
full_path="/sys/class/net/$interface"

if [ ! -z "${interface##wwan*}" ] ; then
	echo {}
	return
fi

if [ ! -L $full_path ] ; then
	echo {}
	return
fi

device="/dev/$(ls /sys/class/net/$interface/device/usbmisc)"

imei=$(uqmi -s -d $device --get-imei | cut -d "\"" -f 2)
msisdn=$(uqmi -s -d $device --get-msisdn  | cut -d "\"" -f 2)
data_status=$(uqmi -s -d $device --get-data-status | cut -d "\"" -f 2)
iccid=$(uqmi -s -d $device --get-iccid | cut -d "\"" -f 2)
imsi=$(uqmi -s -d $device --get-imsi | cut -d "\"" -f 2)

json_load "$(uqmi -s -d $device --get-serving-system)"
json_get_vars registration plmn_mcc plmn_mnc plmn_description roaming

json_load "$(uqmi -s -d $device --get-signal-info)"
json_get_vars type rssi rsrq rsrp snr

json_init
json_add_string registration $registration
json_add_int plmn_mcc $plmn_mcc
json_add_int plmn_mnc $plmn_mnc
json_add_string plmn_description $plmn_description
json_add_boolean roaming $roaming
json_add_string type $type
json_add_int rssi $rssi
json_add_int rsrq $rsrq
json_add_int rsrp $rsrp
json_add_int snr $snr
json_add_string data_status $data_status
json_add_int iccid $iccid
json_add_int imsi $imsi
json_add_int imei $imei
json_add_int msisdn $msisdn
json_close_object
echo "$(json_dump)"

