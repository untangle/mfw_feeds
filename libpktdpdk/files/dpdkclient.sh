#!/bin/ash

/etc/init.d/packetd stop 

#rmmod igb_uio
#rmmod uio_pci_generic
#rmmod vfio
#rmmod vfio-pci
#rmmod vhost
#rmmod vhost-net
insmod /overlay/vhost.ko
insmod /overlay/vhost_net.ko
#modprobe igb_uio
#modprobe uio_pci_generic
#modprobe vfio
#modprobe vfio-pci
#modprobe vhost
#modprobe vhost-net
sysctl -w vm.nr_hugepages=512
mkdir -p /dev/hugepages
dpdk-hugepages --mount

dpdk-devbind -b igb 02:00.0
dpdk-devbind -b igb 03:00.0
dpdk-devbind -b igb 04:00.0
dpdk-devbind -b igb 05:00.0
dpdk-devbind -b ixgbe 08:00.0
dpdk-devbind -b ixgbe 09:00.0

dpdk-devbind -b uio_pci_generic 04:00.0
dpdk-devbind -b uio_pci_generic 09:00.0
dpdk-devbind --status-dev net

DPDK_IDLE_DELAY=1000 DPDK_STARTUP_DELAY=0 DPDK_USE_TX_RING=1 \
	DPDK_VHOST_ARG="virtio_user0,path=/dev/vhost-net,queues=2,queue_size=1024,iface=wg0" \
	DPDK_TX_BUFFERS=2 DPDK_BYPASS_GO=3 ./packetd --dpdk --no-cloud
#DPDK_STARTUP_DELAY=0 DPDK_USE_TX_RING=1 DPDK_VHOST_ARG= DPDK_TX_BUFFERS=2 DPDK_BYPASS_GO=0 ./packetd --dpdk
#DPDK_VHOST_ARG="virtio_user0,path=/dev/vhost-net,queues=2,queue_size=1024" DPDK_RING_THREADS=2 DPDK_TX_BUFFERS=2 DPDK_BYPASS_GO=3 ./packetd --dpdk
#DPDK_RING_THREADS=2 DPDK_TX_BUFFERS=2 DPDK_VHOST_ARG="" DPDK_BYPASS_GO=3 ./packetd --dpdk
#DPDK_TX_BUFFERS=1 DPDK_BYPASS_GO=3 ./packetd.works3 --dpdk
#DPDK_VHOST_ARG="" DPDK_TX_BUFFERS=2 DPDK_BYPASS_GO=3 ./packetd --dpdk
#./dpdk-testpmd -l 0,1 -a 03:00.0 -a 09:00.0 --vdev=virtio_user0,path=/dev/vhost-net,queues=1,queue_size=1024 --vdev=virtio_user1,path=/dev/vhost-net,queues=1 -- -i
#./dpdk-testpmd -l 0,1 -a 03:00.0 -a 09:00.0 --vdev=virtio_user0,path=/dev/vhost-net,queues=1,queue_size=1024 --log-level=eal,8  --log-level=bus,8 --log-level=pmd,8 -- -i
#DPDK_INIT_ARG="--vdev=virtio_user0,path=/dev/vhost-net,queues=1" ./packetd --dpdk
#./dpdk-testpmd -l 0-3 -a 03:00.0 --log-level=eal,8 -- -i
#./dpdk-testpmd -l 0-3 -a 03:00.0 --vdev=virtio_user0,path=/dev/vhost-net,queues=1,queue_size=1024 --log-level=eal,8 -- -i
#./dpdk-testpmd -l 0,1 -a 03:00.0 --vdev=virtio_user0,path=/dev/vhost-net,queues=1,queue_size=1024 --log-level=eal,8 -- -i

#./dpdk-testpmd -c 0xF --log-level=eal,8 -- -i
#./dpdk-testpmd -c 0xF --log-level=eal,8 -- -i
#./dpdk-testpmd -c0xF --log-level=eal,8 

#ip addr add 192.168.2.1/24 dev tap0
#ip link set dev tap0 up


