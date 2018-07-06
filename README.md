-[![License: GPL v2](https://img.shields.io/badge/License-GPL%20v2-blue.svg)](https://www.gnu.org/licenses/old-licenses/gpl-2.0.en.html)

Building OpenWRT with the Untangle Feed
=======================================

The steps below describe building an OpenWRT x86 image with support for
running packetd. This is accomplished by pulling in a custom feed with
the packetd application and a couple of dependencies.

The Docker build method uses a volume to perform the build, you can mix
both methods at any time: the build results will always be on your local
disk.

Building in Docker:
-------------------

Grab the Untangle-patched OpenWRT git repository:
```
git clone https://github.com/untangle/openwrt.git
cd openwrt
```

Build it for your intended device and libc targets:
```
docker-compose -f Dockerfile-build.yml run build (-d x86_64|wrt3200, -l musl|glibc)
```

The OpenWRT documentation warns that building with -jN can cause
issues. If you hit a failure with -jN the first thing to do is to rerun
with -j1. Adding V=s increases verbosity so that you'll have output to
look at when/if something still fails to build:

```
docker-compose -f Dockerfile-build.yml run build (-d x86_64|wrt3200, -l musl|glibc) -j1 V=s
```

Building directly on a Stretch host:
------------------------------------

Install build dependencies:
```
apt-get install build-essential curl file gawk gettext git libncurses5-dev libssl-dev python2.7 swig time unzip wget zlib1g-dev
```

Grab the Untangle-patched OpenWRT git repository:
```
git clone https://github.com/untangle/openwrt.git
cd openwrt
```

Build it for your intended libc target:
```
./build.sh (-d x86_64|wrt3200, -l musl|glibc)
```

The OpenWRT documentation warns that building with -jN can cause
issues. If you hit a failure with -jN the first thing to do is to rerun
with -j1. Adding V=s increases verbosity so that you'll have output to
look at when/if something still fails to build:
```
./build.sh (-d x86_64|wrt3200, -l musl|glibc) -j1 V=s
```

Setting up a VM
===============

If everything built correctly you should have a gzipped image in the
bin directory (to use with for instance QEMU):
```
gunzip bin/targets/x86/64*/openwrt-x86-64-combined-ext4.img.gz
```

There is also a VirtualBox disk image:
```
bin/targets/x86/64*/openwrt-x86-64-combined-ext4.vdi
```

In QEMU
-------
To launch OpenWRT x86\_64 in QEMU, make sure br0 is a pre-existing
bridge with external access. On my machine, it looks like this, with
eth0 being the actual physical interface connected to my network:
```
# ip ad show br0
3: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
    link/ether e0:cb:4e:a9:80:64 brd ff:ff:ff:ff:ff:ff
    inet 172.17.17.6/24 brd 172.17.17.255 scope global br0
       valid_lft forever preferred_lft forever
# ip ad show eth0
2: eth0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast master br0 state UP group default qlen 1000
    link/ether e0:cb:4e:a9:80:64 brd ff:ff:ff:ff:ff:ff
```

Then run something like (br10 will be created dynamically):
```
~/ngfw_pkgs/untangle-development-kernel/files/usr/bin/openwrt-qemu-run -f openwrt-x86-64-combined-ext4.img -b br0 -c br10 -t g
```

In Virtualbox
-------------

Create a new VM using the vdi image, but *do not boot it* before
changing its network settings: you want the 1st interface to be some
some of an internal net, without a need for connectivity (this will be
eth0, which OpenWRT uses as its internal interface), and the 2nd
interface should ideally be bridged (this will be eth1, used as the
external interface by OpenWRT)

Running the image
=================

Accessing the host
------------------

After starting your VM, the external interface is firewalled off, and
you need to change that:
```
uci set firewall.@zone[1].input=ACCEPT
uci commit
/etc/init.t/firewall restart
```

You can now ssh into your the host's eth1 IP, which it should have
grabbed from DHCP through your bridged interface:
```
ip ad show eth1
```

Beware: SSH will by default not require a password!

Using the OpenWRT admin UI
--------------------------

You can also install the OpenWRT admin UI if you need it:
```
opkg update
opkg install uhttpd
opkg install luci
```

Installing extra programs
-------------------------

Other useful programs can also be added, for instance:
```
opkg install tcpdump
```

Trying out packetd
==================

Boot the image and enable ssh as described above. At the OpenWRT prompt
start packetd:
```
packetd
```

Packetd is now running, and exposes its REST interface on port 8080, but
we aren't sending it any packets yet. From a separate terminal, ssh in
and run update\_rules to insert the iptables rules needed to start
passing traffic to packetd:
```
packetd_rules
```

Now bask in the packetd glory.
