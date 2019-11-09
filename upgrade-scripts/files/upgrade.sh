#!/bin/sh

usage() {
    echo "Usage: $0 <options>"
    echo "Options: "
    echo "  -s - simulate - do not upgrade - exit 0 if upgrade available, 1 otherwise or error"
    exit 1;
}

for f in /etc/os-release /tmp/sysinfo/board_name /etc/config/uid ; do
    if [ ! -f $f ] ; then
        echo "Missing $f file"
        exit 1
    fi
done

source /etc/os-release
source /usr/share/libubox/jshn.sh

FULL_VERSION="$(grep VERSION_ID /etc/os-release | cut -d '"' -f 2)"
VERSION="`grep VERSION_ID /etc/os-release | sed -rn 's/.*v(\d{1,2}\.\d{1,2}\.?\d{0,2}).*/\1/p'`"
BOARD="`cat /tmp/sysinfo/board_name | tr -d '[ \t\r\n]'`"

if [[ -f "/tmp/sysinfo/untangle_board_name" ]] ; then
    BOARD="`cat /tmp/sysinfo/untangle_board_name | tr -d '[ \t\r\n]'`"
fi

UID="`cat /etc/config/uid | tr -d '[ \t\r\n]'`"
DEVICE="`grep LEDE_DEVICE_MANUFACTURER_URL /etc/os-release | sed -rn 's/.*sdwan-(.*?)-Packages.*/\1/p'`"

ARGS="version=${VERSION}&fullVersion=${FULL_VERSION}&board=${BOARD}&uid=${UID}"
URL="https://updates.untangle.com/api/v1/releases/${DEVICE}/latest?${ARGS}"
OUTPUT="/tmp/upgrade.json"
SIMULATE=0

while getopts "s" o; do
    case "${o}" in
        s)
            SIMULATE=1
            ;;
        *)
            usage
            ;;
    esac
done


echo "Checking for new releases with URL: ${URL}"

rm -f $OUTPUT

wget -t 5 --timeout=30 -q -O $OUTPUT $URL
if [ $? != 0 ] ; then
    echo "Failed to reach upgrade server."
    exit 1
fi

# Fake response
# cat> $OUTPUT <<EOF
# {
#   "filename": "foobar123",
#   "version": "v0.1.0beta0-200-aaaaaaaaa",
#   "device": "linksys,shelby",
#   "url": "http://metaloft.com/fav.ico",
#   "timestamp": "1234124",
#   "images": [
#     {
#       "filename": "foobar",
#       "format": "foobar",
#       "type": "foobar",
#       "url": "http://metaloft.com/fav.ico",
#       "preferred": true,
#       "timestamp": "string",
#       "version": "string"
#     }
#   ],
#   "packages": [
#     {
#       "name": "string",
#       "version": "string",
#       "device": "string",
#       "description": "string"
#     }
#   ]
# }
# EOF

if [ -z "$OUTPUT" ] ; then
    # no upgrade available
    exit 1
fi

json_init
json_load_file $OUTPUT
json_get_var NEWVER version
json_get_var IMAGEURL url

if [ -z "$NEWVER" ] ; then
    echo "Invalid response (no version found)"
    exit 1
fi
if [ -z "$IMAGEURL" ] ; then
    echo "Invalid response (no URL found)"
    exit 1
fi

echo
echo "Current version: ${VERSION}"
echo "Newest  version: ${NEWVER}"
echo

if [ $SIMULATE == 1 ] ; then
    echo "Upgrade available."
    # upgrade available
    exit 0
fi

echo "Downloading upgrade image..."
wget -t 5 --timeout=30 -q -O /tmp/sysupgrade.img $IMAGEURL
if [ $? != 0 ] ; then
    echo "Failed to download image."
    exit 1
fi

echo "Upgrading..."
echo

/sbin/sysupgrade /tmp/sysupgrade.img


