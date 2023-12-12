#!/bin/sh

grab_intf_name() {
	interfaces=$(uci show network | grep "$1" | cut -d"." -f2)
}

# Monitor ip link status for interfaces.
ip -o monitor link | while read -r index interface status remaining; do
	iface=$(printf '%s\n' "$interface" | sed -E 's/(@.*)?:$//')
	operstate=$(printf '%s\n' "$remaining" | grep -Eo ' state [^ ]+' | sed 's/^ state //')

	grab_intf_name "$iface"
	# | tr '[:upper:]' '[:lower:]' does not work on busybox atm
	if [ "$operstate" != "UP" ] && [ "$operstate" != "DOWN" ]; then
		logger -p Error -t "Interface Watch" "Not acting on operating state: $operstate"
		continue
	fi

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

		if [ "$operstate" = "UP" ]; then
			ubus call network.interface down "{ \"interface\" : \"$intfc\" }"
			ubus call network reload
			ubus call network.interface up "{ \"interface\" : \"$intfc\" }"
			ubus call network reload
		fi

		logger -p Info -t "Interface Watch" "Interface $intfc of device $interface changed state to $operstate"
	done

done

exit 1
