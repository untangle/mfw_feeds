#!/bin/sh

grab_intf_name() {
	interfaces=$(uci show network | grep "$1" | cut -d"." -f2)
}

# Monitor ip link status for interfaces.
ip -o monitor link | while read -r index interface status remaining; do
	iface=$(printf '%s\n' "$interface" | sed -E 's/(@.*)?:$//')
	operstate=$(printf '%s\n' "$remaining" | grep -Eo ' state [^ ]+' | sed 's/^ state //')

	# | tr '[:upper:]' '[:lower:]' does not work on busybox atm
	grab_intf_name "$iface"
	if [ "$operstate" = "UP" ]; then
		action="up"
	elif [ "$operstate" = "DOWN" ]; then
		action="down"
	else
		logger -p Error -t "Interface Watch" "Unknown operating state: $operstate"
		continue
	fi

	[ "$operstate" = "UP" ] && ubus call network reload

	# For both ipv6 and ipv4
	echo "$interfaces" | while read -r intfc; do
		# if interface empty string
		if [ -z "$intfc" ]; then
			continue
		fi

		# Check intfc actually exists
		ubus -S list "network.interface.$intfc" >/dev/null || {
			logger -p Debug -t "Interface Watch" "Interface $intfc not found in UBUS networks"
			continue
		}

		[ "$operstate" = "UP" ] && ubus call network.interface $action "{ \"interface\" : \"$intfc\" }"
		logger -p Info -t "Interface Watch" "Interface $intfc of device $interface changed state to $operstate"
	done

done

exit 1
