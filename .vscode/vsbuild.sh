#!/bin/bash
##
## Compile sync-settings and install if no errors.
##
TARGET=$1

# Break target down by commas into an array.
TARGET_ADDRESSES=()
while IFS=',' read -ra ADDRESSES; do
    for address in "${ADDRESSES[@]}"; do
        TARGET_ADDRESSES+=($address)
    done
done <<< "$TARGET"

for target_address in "${TARGET_ADDRESSES[@]}"; do
    echo "Copying to $target_address..."
    ssh-copy-id root@$target_address

    rsync=$(ssh root@$target_address "which rsync")
    if [ "$rsync" = "" ] ; then
        ssh root@$target_address "opkg update; opkg install rsync"
    fi

    rsync -r -a -v --chown=root:root wan-manager/files/* root@$target_address:/usr/bin
    # rsync -r -a -v --chown=root:root pyconnector/files/* root@$target_address:/usr/bin
    # rsync -r -a -v --chown=root:root strongswan-full/files/override.ipsec.init root@$target_address:/etc/init.d/ipsec
    # rsync -r -a -v --chown=root:root pyconnector/files/pyconnector root@$target_address:/usr/bin/pyconnector
    # rsync -r -a -v --chown=root:root pyconnector/files/pyconnector.init root@$target_address:/etc/init.d/pyconnector
    rsync -r -a -v --chown=root:root sync-settings/files/speedtest.sh root@$target_address:/usr/bin/speedtest.sh
    # rsync -r -a -v --chown=root:root speedtest-cli-dbg root@$target_address:/root/speedtest-cli-dbg

    # Tests
    target_sync_path=$(ssh root@$target_address "find /usr -name tests | grep '\(site-packages\|dist-packages\)/tests' | head -1")
    if [ "$target_sync_path" != "" ] ; then
        rsync -r -a -v runtests/files/usr/lib/python/tests/* root@$target_address:$target_sync_path
    fi

    # Restd 
    target_sync_path=$(ssh root@$target_address "find /usr -name restd | grep '\(site-packages\|dist-packages\)/restd' | head -1")
    if [ "$target_sync_path" != "" ] ; then
        rsync -r -a -v restd/files/usr/lib/python/restd/* root@$target_address:$target_sync_path
    fi
done
