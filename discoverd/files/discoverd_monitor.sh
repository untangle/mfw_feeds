#!/bin/sh

while true; do
    lsof=$(lsof | grep discoverd | grep netlink | wc -l)
    if [[ "$lsof" -eq "100" ]]; then
        touch /tmp/discoverd_netlink_leak
        pid=$(pgrep discoverd)
        kill -QUIT $pid
        sleep 5
        # Restart discoverd
        /etc/init.d/discoverd restart
    fi
    sleep 1800
done