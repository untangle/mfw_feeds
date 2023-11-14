#!/bin/sh

if [ -z "$NCPUS" ]; then
	NCPUS=$(grep processor /proc/cpuinfo | wc -l)
fi

if [ -z "$DEVLIST" ]; then
	DEVLIST=$(cd /sys/class/net; ls -1d et1_* | sort -t_ -k2n)
fi

case $1 in
show)
	for d in $DEVLIST
	do
		irqs=$(grep "iavf-$d-" /proc/interrupts | awk -F: '{print $1}')
		printf "%s	irqs: " $d
		aflist=
		for irq in $irqs
		do
			al=$(cat /proc/irq/$irq/smp_affinity_list)
			aflist="$aflist $al"
			printf "%5d" $irq
		done
		printf "\n\tcore: "
		for al in $aflist
		do
			printf "%5d" $al
		done
		printf "\n"
	done
	;;

set)
	af=0
	for d in $DEVLIST
	do
		# Setup CPU affinity
		irqs=$(grep "iavf-$d-" /proc/interrupts | awk -F: '{print $1}')
		for irq in $irqs
		do
			# echo "Set smp_affinity: $d irq=$irq $af"
			echo $af > /proc/irq/$irq/smp_affinity_list
			af=$((af+1))
			[ $af -eq $NCPUS ] && af=0
		done
	done
	;;

*)
	echo "Usage: set_affinity show|set"
	exit 1
esac

exit 0
