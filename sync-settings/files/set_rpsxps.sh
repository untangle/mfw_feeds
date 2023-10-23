#!/bin/sh

if [ -z "$DEVLIST" ]; then
	DEVLIST=$(cd /sys/class/net; ls -1d et1_* | sort -t_ -k2n)
fi

# 40 CPUs
CPUMASK_ALL="ff,ffffffff"

case $1 in
show)
	for d in $DEVLIST
	do
		for rx in $(cd /sys/class/net/$d/queues; ls -1d rx-*)
		do
			mask=$(cat /sys/class/net/$d/queues/$rx/rps_cpus)
			echo $d $rx  $mask
		done
		for tx in $(cd /sys/class/net/$d/queues; ls -1d tx-*)
		do
			mask=$(cat /sys/class/net/$d/queues/$tx/xps_cpus)
			echo $d $tx  $mask
		done
	done
	;;
set|revert)
	[ $1 = revert ] && CPUMASK_ALL=0

	for d in $DEVLIST
	do
		for rx in $(cd /sys/class/net/$d/queues; ls -1d rx-*)
		do
			echo $CPUMASK_ALL > /sys/class/net/$d/queues/$rx/rps_cpus
		done
		for tx in $(cd /sys/class/net/$d/queues; ls -1d tx-*)
		do
			echo $CPUMASK_ALL > /sys/class/net/$d/queues/$tx/xps_cpus
		done
	done
	;;
*)
	echo "Usage: set_rpsxps show|set|revert"
	exit 1
	;;
esac

exit 0
