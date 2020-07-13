#!/bin/sh

[ -x /usr/sbin/openvpn ] || exit 1

[ -n "$INCLUDE_ONLY" ] || {
	. /lib/functions.sh
	. /lib/functions/network.sh
	. ../netifd-proto.sh
	init_proto "$@"
}

proto_openvpn_init_config() {
	available=1
	no_device=1
	proto_config_add_string "ifname"
	proto_config_add_string "config"
	proto_config_add_string "authfile"
	proto_config_add_string "wanif"
	proto_config_add_string "wanif6"
	proto_config_add_defaults
}

get_config_param() {
	local variable="$1"
	local config="$2"
	local option="$3"
	local default="$4"

	local value="$(sed -rne 's/^[ \t]*'"$option"'[ \t]+([^ \t]+)[ \t]*$/\1/p' "$config" | tail -n1)"
	export -n "$variable=${value:-$default}"
}

proto_openvpn_setup() {
	local cfg="$1"
	local iface="$2"

	local dev_type opts

	local ifname config authfile wanif wanif6 $PROTO_DEFAULT_OPTIONS
	json_get_vars ifname config authfile wanif wanif6 $PROTO_DEFAULT_OPTIONS

	[ -n "$ifname" ] || get_config_param ifname "$config" dev
	[ -z "$ifname" ] && {
		echo "openvpn[$$]" "Failed to get ifname"
		proto_notify_error "$cfg" "NO_IFNAME_SET"
		proto_block_restart "$cfg"
		return 1
	}
	append opts "--dev $ifname"

	get_config_param dev_type "$config" dev-type
	case "${dev_type:-$ifname}" in
		tap*) dev_type="tap" ;;
		*) dev_type="tun" ;;
	esac
	append opts "--dev-type $dev_type"

	[ -n "$metric" ] || get_config_param metric "$config" metric 0
	append opts "--setenv METRIC ${metric}"

	[ "$peerdns" = 1 ] && append opts "--setenv PEERDNS 1"

	[ "$defaultroute" = 1 ] && append opts "--setenv DEFAULTROUTE 1"

	[ -n "$authfile" ] && {
		append opts "--auth-user-pass $authfile"
	}

	[ -z "$wanif" ] || [ -z "$wanif6" ] && {
		append opts "--nobind"
	}

	[ -n "$wanif" ] || [ -n "$wanif6" ] && {
		local ipaddr ip6addr

		network_get_ipaddr ipaddr "$wanif"
		network_get_ipaddr6 ip6addr "$wanif6"

		if [ -z "$ipaddr" ] && [ -z "$ip6addr" ]; then
			proto_notify_error "$cfg" "NO_WAN_LINK"
			exit
		fi

		[ -n "$ipaddr" ] && {
			append opts "--bind --local $ipaddr"
		}

		# Currently we are unable to bind to interfaces
		# on both an IPv4 and IPv6 address. 
		# This should be resolved in OpenVPN versions (>2.5):
		# https://community.openvpn.net/openvpn/ticket/556?__cf_chl_jschl_tk__=ab3c77c30fe2d267e1c2bd>                
		[ -z "$ipaddr" ] && [ -n "$ip6addr" ] && {
			append opts "--bind --local $ip6addr"
		}
	}
	
	proto_run_command "$cfg" /usr/sbin/openvpn \
		--syslog "openvpn($cfg)" \
		--status "/var/run/openvpn.${cfg}.status" \
		--config "$config" \
		--setenv INTERFACE "$cfg" \
		--resolv-retry infinite \
		--script-security 3 \
		--route-up /lib/netifd/openvpn-up \
		--route-pre-down /lib/netifd/openvpn-down \
		$opts
}

proto_openvpn_teardown() {
	local cfg="$1"
	proto_kill_command "$cfg"
}

[ -n "$INCLUDE_ONLY" ] || {
	add_protocol openvpn
}
