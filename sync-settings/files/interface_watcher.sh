#!/bin/sh

grab_intf_name() {
	interfaces=$(uci show network | grep $1 | cut -d"." -f2)
}

# Monitor ip link status for interfaces.
ip -o monitor link | while read -r index interface status remaining; do
	iface=$(printf '%s\n' "$interface" | sed -E 's/(@.*)?:$//')
	operstate=$(printf '%s\n' "$remaining" | grep -Eo ' state [^ ]+' | sed 's/^ state //')

	# If iface goes to UP
	if [ "$operstate" = "UP" ]; then
		echo "PEOS"

		# For both ipv6 and ipv4
		grab_intf_name "$iface"
		echo "$interfaces" | while read -r line; do ifup "$line"; done

	fi

	logger -t "Interface Watch" "Interface $iface changed state to $operstate"
done

exit 1
