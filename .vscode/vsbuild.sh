#!/bin/bash
##
## Compile sync-settings and install if no errors.
##
TARGET=$1
PORT=22

GREEN=$'\e[0;32m'
NC=$'\e[0m'

# Break target down by commas into an array.
TARGET_ADDRESSES=()
while IFS=',' read -ra ADDRESSES; do
	for address in "${ADDRESSES[@]}"; do
		TARGET_ADDRESSES+=("$address")
	done
done <<<"$TARGET"

for target_address in "${TARGET_ADDRESSES[@]}"; do

	echo "${GREEN}Copying to $target_address ...${NC}"

	ssh-copy-id root@"$target_address"

	isEos=true
	if [ "$(ssh -p "$PORT" root@"$target_address" "uname -n")" == "mfw" ]; then
		isEos=false
		echo "${GREEN}Bare MFW found${NC}"
	else
		echo "${GREEN}MFW in EOS found${NC}"
	fi

	target_sync_path=""
	mfw_dir=""
	if [ "$isEos" != true ]; then
		# bare MFW target
		rsync=$(ssh -p "$PORT" root@"$target_address" "which rsync")
		if [ "$rsync" = "" ]; then
			ssh -p "$PORT" root@"$target_address" "opkg update; opkg install rsync"
		fi

		target_sync_path="/usr/bin"
	else
		target_sync_path="/mfw/usr/bin"
		mfw_dir="/mfw"
	fi

	echo "${GREEN}Copying to $target_sync_path... ${NC}"

	rsync -r -a -v --chown=root:root wan-manager/files/* root@"$target_address":"$target_sync_path"
	rsync -r -a -v --chown=root:root credentials/files/credentials.json root@"$target_address":"$mfw_dir"/etc/config/credentials.json
	# rsync -r -a -v --chown=root:root pyconnector/files/* root@$target_address:/usr/bin
	# rsync -r -a -v --chown=root:root strongswan-full/files/override.ipsec.init root@$target_address:/etc/init.d/ipsec
	# rsync -r -a -v --chown=root:root pyconnector/files/pyconnector root@$target_address:/usr/bin/pyconnector
	# rsync -r -a -v --chown=root:root pyconnector/files/pyconnector.init root@$target_address:/etc/init.d/pyconnector
	rsync -r -a -v --chown=root:root sync-settings/files/speedtest.sh root@"$target_address":"$target_sync_path"/speedtest.sh
	# rsync -r -a -v --chown=root:root speedtest-cli-dbg root@$target_address:/root/speedtest-cli-dbg

	# Tests
	target_site_packages=$(ssh root@"$target_address" "find $mfw_dir/usr -name tests | grep '\(site-packages\|dist-packages\)/tests' | head -1")
	if [ "$target_site_packages" != "" ]; then
		echo "${GREEN}Copying to $target_site_packages... ${NC}"
		rsync -r -a -v runtests/files/usr/lib/python/tests/* root@"$target_address":$target_site_packages
	fi

	# Restd
	target_site_packages=$(ssh root@"$target_address" "find $mfw_dir/usr -name restd | grep '\(site-packages\|dist-packages\)/restd' | head -1")
	if [ "$target_site_packages" != "" ]; then
		echo "${GREEN}Copying to $target_site_packages... ${NC}"
		rsync -r -a -v restd/files/usr/lib/python/restd/* root@"$target_address":"$target_site_packages"
	fi
done
