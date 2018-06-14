Building Openwrt with the Untangle Feed
=======================================

The steps below describe building an openwrt x86 image with support for
running packetd. This is accomplished by pulling in a custom feed with
the packetd application and a couple of dependencies. This is just an
example of how we might build an openwrt based firmware image.

Install build dependencies:

```
apt-get install build-essential git curl gawk file wget unzip time python2.7 libncurses-dev
```

Grab the mainline openwrt git repository:

```
git clone https://git.openwrt.org/openwrt/openwrt.git
cd openwrt
```

Create feeds.conf and add the path to our custom untangle feed:

```
cp feeds.conf.default feeds.conf
echo src-git untangle https://github.com/untangle/mfw_openwrt.git >> feeds.conf
```

Run the feed update script:

```
./scripts/feeds update -a
```

Unfortunately, it doesn't seem like the feeds infrastructure supports
patching existing packages/makefiles/etc, so we'll manually patch in
conndict support for the kernel and iptables:

```
patch -p1 < feeds/untangle/patches/0001-Add-conndict-support.patch
```

Optional: Install required official packages:

```
/scripts/feeds install python3
/scripts/feeds install diffutils
```

Run the feeds install script to install all of the packages in the
untangle feed (packetd, libnavl, geoip-database and
untangle-python-sync-settings as of this writing):

```
./scripts/feeds install -a -p untangle
```

Optional: Install packages from the other default feeds:

```
/scripts/feeds install some_package_i_want
```

Copy the seed config for our image and run defconfig to expand it:

```
cp feeds/untangle/configs/config.seed.x86 .config
make defconfig
```

Optional: Use menuconfig to add other things to the image:

```
make menuconfig
```

Download everything needed to build the image (use -jN for speed):

```
make -j32 download
```

Build everything:

```
make -j32
```

The openwrt documentation warns that building with -jN can cause
issues. If you hit a failure with -jN the first thing to do is to rerun
with -j1. Adding V=s increases verbosity so that you'll have output to
look at when/if something still fails to build:

```
make -j1 V=s
```

If everything compiled correctly you should have a gzipped image in the
bin directory (to use with for instance QEMU):

```
gunzip bin/targets/x86/64-glibc/openwrt-x86-64-combined-ext4.img.gz
```

There is also a VirtualBox disk image:

```
bin/targets/x86/64-glibc/openwrt-x86-64-combined-ext4.vdi
```

Running the image
=================

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

Accessing the host
------------------

At this point the external interface is firewalled off, and you want to
change that:

```
uci set firewall.@zone[1].input=ACCEPT
uci commit
/etc/init.t/firewall restart
```

You're can now ssh into your the host's eth1 IP, which it should have
grabbed from DHCP your your bridged interface:

```
ip ad show eth1
```

Beware SSH will by default have no password required!

Using the admin UI
------------------

You can also install the admin UI, if you need it and haven't bundled
them in the image:

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

Boot the image and enable ssh as described above. At the openwrt prompt
start packetd:

```
packetd
```

Packetd is now running, and exposes its REST interface on port 8080, but
we aren't sending it any packets yet. From a separate terminal, ssh in
and run update\_rules to insert the iptables rules needed to start
passing traffic to packetd:

```
sh /usr/bin/update_rules
```

Now bask in the packetd glory.
