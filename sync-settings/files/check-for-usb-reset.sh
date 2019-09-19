#!/bin/sh
#
# if we find a usb drive with a file called "reset_settings" in the root
# directory return 0
#

trigger_name="reset_settings"
found=1
drives=`ls /dev/sd[a-z][1-99]`

mkdir /tmp/thumb
for drive in $drives ; do
	mount -o ro $drive /tmp/thumb
	find /tmp/thumb -iname "$trigger_name"* | grep -q $trigger_name
	found=$?
	umount /tmp/thumb
	if [ $found -eq 0 ] ; then
		break
	fi
done
rm -rf /tmp/thumb

exit $found
