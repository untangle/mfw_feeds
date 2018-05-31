OpenWRT in QEMU
===============

Launch with something like:

```
~/ngfw_pkgs/untangle-development-kernel/files/usr/bin/openwrt-qemu-run -f openwrt-x86-64-combined-ext4.img -b br0 -c br10 -t g
```

This should launch OpenWRT (in x86\_64) in QEMU.

In order to access the admin UI if you did not include luci you'll need
to do:

```
opkg update
opkg install uhttpd
opkg install luci
```

You can also install other useful stuff:

```
opkg install tcpdump
```

At this point you can only access the the UI and SSH on the internal
interface. To do this give br10 (internal bridge specified above) an
address on the 192.168.1.x so your host can reach it.

```
ip addr add 192.168.1.2/24 dev br10
```

Then you can login at http://192.168.1.1. If you want to be able to
login on the external interface goto Network & Firewall and change the
WAN zone INPUT from "reject" to "accept" Then you will be able to ssh
and admin from outside (beware SSH may have no password required!)

Building Openwrt with an Untangle Feed
======================================

The steps below describe building an openwrt x86 image with support for
running packetd. This is accomplished by pulling in a custom feed with
the packetd application and a couple of dependencies. This is just an
example of how we might build an openwrt based firmware image.

Install build dependencies (you need an Untangle mirror in your
sources.list):

```
apt-get install untangle-classd libnetfilter-log-dev libnetfilter-queue-dev
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

Run the feeds install script to install all of the packages in the
untangle feed (packetd, libnavl, geoip-database and
untangle-python-sync-settings as of this writing):

```
./script/feeds install -a -p untangle
```

Optional: Install packages from the other default feeds:

```
/script/feeds install some_package_i_want
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
bin directory:

```
gunzip bin/targets/x86/64-glibc/openwrt-x86-64-combined-ext4.img.gz
```

It can then be used with the QEMU steps at the top of this page:

```
ls bin/targets/x86/64-glibc
[...]
openwrt-x86-64-combined-ext4.img
[...]
```

Boot the image and enable ssh as described above. At the openwrt prompt
start packetd:

```
packetd
```

Packetd is running, but we aren't sending it any packets yet. From a
seperate terminal, ssh in and run update\_rules to insert the iptables
rules needed to start passing traffic to packetd:

```
update_rules
```

Now bask in the packetd glory.
