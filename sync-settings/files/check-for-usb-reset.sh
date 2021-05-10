#!/bin/sh
#
# if we find a usb drive with a file called "reset_settings" in the root
# directory return 0
#

trigger_name="reset_settings"
found=0
drives=`ls /dev/sd[a-z][1-99] 2>/dev/null`

mkdir /tmp/thumb
for drive in $drives ; do
	mount -o ro $drive /tmp/thumb 1>/dev/null 2>&1
	if [ $? -ne 0 ] ; then
		continue
	fi
	find /tmp/thumb -iname "$trigger_name"* | grep -q $trigger_name
	if [ $? -eq 0 ] ; then
		found=1
	fi
	umount /tmp/thumb
	if [ $found -eq 1 ] ; then
		break
	fi
done
rmdir /tmp/thumb

exit $found
