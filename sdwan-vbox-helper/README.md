# MFW - Command Line Interface<br/>*mfw-cli*

## About

**mfw-cli** was born from the need to avoid the daily (or often)<br/>
repetitive manual process of creating new SD-WAN virtual machines from latest builds.<br/>
It can be helpful for QA enginners too when dealing with testing this builds.

It uses Jenkins JSON APIs to fetch the data.

It provides following features:
* display info and status about latest OpenWrt builds
* download any artifact for a specific build
* create VirtualBox instances from VDI artifacts

> **Note:** *mfw-cli* is written and tested only on Debian 10

## Requirements

The mfw-cli requires:
* **python3** (`#!/usr/bin/env python3`)
* **VirtualBox 6** (`vboxmanage`), the version used while developed (it might work with other versions too)
* other system packages: **wget**, **ip**, **grep**, **awk**

> Untangle VPN connection required, otherwise Jenkins APIs are not accessible

## Install

[**Download mfw-cli (mfw.py)**](https://github.com/untangle/mfw_build/raw/master/sdwan-vbox-helper/mfw.py)

The mfw-cli is not actually installed, you just have the run the python script (`mfw.py`). To run it just type:
```
~$ python mfw.py [options]
```

To make it more accessible, see the guideline below.

Get rid of the `python` prefix type:
```
~$ chmod +x ./mfw.py

# then you can run it like
~$ ./mfw.py [options]
```

Make it available system wide:
```
~$ mv mfw.py /usr/local/bin/mfw

# if requires extra privileges use sudo
~$ sudo mv mfw.py /usr/local/bin/mfw

# then you can run it in the easiest way from anywhere
~$: mfw [options]
```

Instead of `/usr/local/bin/` you can use other path found in system $PATH.<br/>
See list of paths in your system:

```
~$ echo "${PATH//:/$'\n'}"
```


## Usage

Below is the `mfw` help command showing available options

```
~$ mfw -h

usage: mfw [-h] [-l [LIMIT] | -i [INSTALL_NUMBER] | -d [BUILD_NUMBER]] [-v]

Untangle SD-WAN Router tools
- info and status about latest builds
- download artifacts
- create VirtualBox instances from x86-64 vdi

optional arguments:
  -h, --help           show this help message and exit
  -l [LIMIT]           show info and latest 10 or specified by LIMIT builds
  -i [INSTALL_NUMBER]  download specified by INSTALL_NUMBER (build number) and creates VBox with it
  -d [BUILD_NUMBER]    list and download available artifacts for a specific build number
  -v                   show program's version number and exit

```

## Examples

### Listing and status

Running `mfw` without arguments will show, by default, the status for the last 10 builds

```
~$ mfw

MFW » openwrt-18.06

Build stability: 3 out of the last 5 builds failed.
Last successful build: 883

no. | status  | timestamp      | dur.    | vdi file name
-----------------------------------------------------------
883 | SUCCESS | Oct 02 02:47PM | 0:23:37 | sdwan-x86-64-combined_v1.1-9-g6e953de52a_20191002T0448.vdi
882 | FAILURE | Oct 02 02:28PM | 0:25:49 | sdwan-x86-64-combined_v1.1-9-g6e953de52a_20191002T0432.vdi
881 | FAILURE | Oct 02 12:19PM | 2:15:06 | sdwan-x86-64-combined_v1.1-9-g6e953de52a_20191002T0359.vdi
880 | FAILURE | Oct 02 12:18PM | 2:09:31 | None
879 | SUCCESS | Oct 02 12:13PM | 2:17:31 | sdwan-x86-64-combined_v1.1-9-g6e953de52a_20191002T0308.vdi
878 | SUCCESS | Oct 02 12:02PM | 2:27:47 | sdwan-x86-64-combined_v1.1-9-g6e953de52a_20191002T0241.vdi
877 | SUCCESS | Oct 02 12:00PM | 2:28:05 | sdwan-x86-64-combined_v1.1-7-g5ce74334aa_20191002T0212.vdi
876 | FAILURE | Oct 02 09:46AM | 2:25:16 | None
875 | FAILURE | Oct 02 09:43AM | 0:30:26 | None
874 | FAILURE | Oct 01 05:16PM | 0:29:22 | None
```

It can be set a limit on how many builds to show, by running `mfw -l <limit_number>`

```
~$ mfw -l 3

MFW » openwrt-18.06

Build stability: 3 out of the last 5 builds failed.
Last successful build: 883

no. | status  | timestamp      | dur.    | vdi file name
-----------------------------------------------------------
883 | SUCCESS | Oct 02 02:47PM | 0:23:37 | sdwan-x86-64-combined_v1.1-9-g6e953de52a_20191002T0448.vdi
882 | FAILURE | Oct 02 02:28PM | 0:25:49 | sdwan-x86-64-combined_v1.1-9-g6e953de52a_20191002T0432.vdi
881 | FAILURE | Oct 02 12:19PM | 2:15:06 | sdwan-x86-64-combined_v1.1-9-g6e953de52a_20191002T0359.vdi
```

### Downloads

Download option is interactive. The files (artifacts) are categorized based on appliance.<br/>
To download files from a specific build run `mfw -d <build_number>`

```
~$ mfw -d 883

MFW » openwrt-18.06 #883
------------------------
Build number:  883
Is building:   False
Build result:  SUCCESS
Timestamp:     Oct 02 02:47PM
Duration:      0:23:37
Est. duration: 1:42:58
------------------------
Select appliance

1) sdwan-x86-64
2) sdwan-wrt1900acs
3) sdwan-wrt3200acm
4) sdwan-wrt32x
5) sdwan-espressobin
6) sdwan-omnia
7) openwrt-x86-64
8) openwrt-wrt3200acm
9) ALL

Type "x" to exit

Choose: _
```

Selecting option 5 from categories will list available files for espressobin

```
Select artifact

1) sdwan-espressobin-ext4_v1.1-9-g6e953de52a_20191002T0454.img.gz
2) sdwan-espressobin-initramfs-kernel_v1.1-9-g6e953de52a_20191002T0454.img
3) sdwan-espressobin-Packages_v1.1-9-g6e953de52a_20191002T0454.txt
4) sdwan-espressobin_v1.1-9-g6e953de52a_20191002T0454.img.gz

Type "x" to exit

Choose: _
```

Selecting the 4th option will start download the sdwan-espressobin_v1.1-9 image

```
Choose: 4
Downloading to /home/dan/untangle/mfw_build/sdwan-vbox-helper ...

sdwan-espressobin_v1.1-9-g6e95350 100%[==================================>]  26.84M  4.74MB/s    in 15s
```
> **Important!** Files are downloaded in the current folder.<br/>
> There is no option yet to choose where to save them.

### Creating VirtualBox instances

Creates VirtualBox machine using x86-64 vdi file.<br/>
There is a naming convention so the VirtualBox and VDI file are named *sdwan-<build_number>*.<br/>
The mfw-cli tries to manage conflicts if a box with the same name already exists and/or running.

To download and create the box instance for a specific build, run `mfw -i <build_number>`


```
~$ mfw -i 883

MFW » openwrt-18.06 #883
------------------------
Build number:  883
Is building:   False
Build result:  SUCCESS
Timestamp:     Oct 02 02:47PM
Duration:      0:23:37
Est. duration: 1:42:58
------------------------
Downloading as "sdwan-883.vdi" to /home/dan/untangle/mfw_build/sdwan-vbox-helper ...

sdwan-883.vdi                     100%[==================================>]  31.00M  5.38MB/s    in 16s
```

Before creating the machine, you must choose the interface for the box bridged adapter<br/>
from a list provided by querying the system. In below case was option 2 (enp0s31f6)

```
Select interface (device) for the "sdwan-883" box bridged adapter:
1) lo -> 127.0.0.1/8
2) enp0s31f6 -> 192.168.101.206/24
3) tun0 -> 172.17.0.46
4) or enter manually ...

Choose (1,2,3,4): _
```

Then virtual box named `sdwan-<build_number>` is created,<br/>
having attached the media storage with the same name, which was previously downloaded.
```
Choose (1,2,3,4): 2
Virtual machine 'sdwan-883' is created and registered.
UUID: 61e1dc74-c0a8-463a-9ddc-c42a87661631
Settings file: '/home/dan/VirtualBox VMs/sdwan-883/sdwan-883.vbox'
Waiting for VM "sdwan-883" to power on...
VM "sdwan-883" has been successfully started.
```


**Further considerations**

After the box is up and running, to gain access on it via SSH,<br/>
or to browse the admin interface, you have to edit the `settings.json` file.

Inside the box run:
```
root@mfw:/# vi /etc/config/settings.json
```

Find the **access** firewall table and set `"enabled"` to `true` on the following rules:

* Accept SSH on WANs (TCP/22)
* Accept HTTP on WANs (TCP/80)
* Accept HTTPS on WANs (TCP/443) (eventually)

See below how it looks like for SSH on WANs rule

```
{
    "action": {
        "type": "ACCEPT"
    },
    "conditions": [
        {
            "op": "==",
            "type": "IP_PROTOCOL",
            "value": "6"
        },
        {
            "op": "==",
            "type": "DESTINATION_PORT",
            "value": "22"
        },
        {
            "op": "==",
            "type": "SOURCE_INTERFACE_TYPE",
            "value": "wan"
        }
    ],
    "description": "Accept SSH on WANs (TCP/22)",
    "enabled": true,
    "ruleId": 10
},
```

After the above changes are saved, to have effect they are applied using `sync-settings` command:
```
root@mfw:/# sync-settings
```

To get the guest IP, in the box type:
```
root@mfw:~# ip addr | grep inet | grep -v inet6
    inet 127.0.0.1/8 scope host lo
    inet 192.168.1.1/24 brd 192.168.1.255 scope global eth0
    inet 192.168.101.167/24 brd 192.168.101.255 scope global eth1
```
In the above case the guest IP is `192.168.101.167`.

Knowing that, the box can be accessed from host via SSH:
```
~$ ssh root@192.168.101.167
The authenticity of host '192.168.101.167 (192.168.101.167)' can't be established.
ECDSA key fingerprint is SHA256:/AOe3YtG06g8ANPCpP54GHG3WmCZtF2B87tB8U0CJCY.
Are you sure you want to continue connecting (yes/no)? yes
Warning: Permanently added '192.168.101.167' (ECDSA) to the list of known hosts.
root@192.168.101.167's password:


BusyBox v1.28.4 () built-in shell (ash)

                    _                    _
        _   _ _ __ | |_ ___  _ __   __ _| | ___
       | | | | '_ \| __/ _ \| '_ \ / _` | |/ _ \
       | |_| | | | | || (_| | | | | (_| | |  __/
        \__,_|_| |_|\__\__,_|_| |_|\__, |_|\___|
                                   |___/

 -----------------------------------------------------
 MFW v1.1-0-g4586f511df, based on OpenWrt 18.06.4
 -----------------------------------------------------
root@mfw:~#
```

If you want to avoid entering the password all the time,<br/>
put the public key on the guest machine (assuming there is already an `id_rsa.pub` key)
```
~$ ssh root@192.168.101.167 "mkdir /root/.ssh && tee -a /root/.ssh/authorized_keys" < ~/.ssh/id_rsa.pub
```

To access the SD-WAN admin interface just browse to</br>
`http://192.168.101.167/admin`


## Final remarks

I'm not a seasoned python coder, neither a linux guru, but if you think this tool is useful, I welcome any suggestions and contributions to improve it.
