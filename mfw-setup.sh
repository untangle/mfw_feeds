#/bin/ash

##
## This script should be run on an initially installed (not configured) system.  It will do the following:
##
## - Setup LAN address and network prefix.
## - Setup /dev/sdb and make as the new overlay.
## - Setup opkg list target to reside on overlay.
##

##
## Update settings
##
SETTINGS_FILE=/etc/config/settings.json
SETTINGS_BACKUP_FILE=/etc/config/settings.backup.json

if [ ! -f $SETTINGS_BACKUP_FILE ]; then
  cp $SETTINGS_FILE $SETTINGS_BACKUP_FILE
fi

read -p "LAN IP Address: " LAN_IP
read -p "LAN Network Prefix: " LAN_PREFIX

sed -i -r \
 's/("v4StaticAddress":) "[^"]+"/\1 "'$LAN_IP'"/; s/("v4StaticPrefix":) \d+/\1 '$LAN_PREFIX'/' \
 $SETTINGS_FILE

sed -i -r \
 '$!N;s/"enabled": false,(\n\s+"description": "Accept SSH on WANs)/"enabled": true,\1/;P;D' \
 $SETTINGS_FILE

sync-settings

##
## Update storage
##
opkg update
opkg install fdisk block-mount rsync

echo "
n
p



i 1
w
" | fdisk /dev/sdb

mkfs.ext4 /dev/sdb1

##
## Setup new overlay.
##
uuid=$(block info | \
	grep sdb1 | \
	sed -r 's/[[:alnum:]]+=/\n&/g' | \
	awk -F= '$1=="UUID"{print $2}' | \
	sed -e 's/"//g' \
)
echo "uuid=$uuid"

uci -q delete fstab.overlay
uci set fstab.overlay="mount"
uci set fstab.overlay.uuid=$uuid
uci set fstab.overlay.target="/overlay"
uci commit fstab

mount /dev/sdb1 /mnt
cp -f -a /overlay/. /mnt
umount /mnt

##
## opkg to overlay
##
OPKG_CONF_FILE=/etc/opkg.conf
sed -i -e \
 '/^lists_dir\s/s:/var/opkg-lists$:/usr/lib/opkg/lists:' \
 $OPKG_CONF_FILE
opkg update

reboot


