#!/bin/sh

usage() {
    echo "Usage: $0 <options>"
    echo "Options: "
    echo "  -s - simulate - do not upgrade - exit 0 if upgrade available, 1 otherwise or error"
    exit 1;
}

# logMessage is used to log a normal stdout message to the logger
logMessage() {
    echo "$1"
    logger -t upgrade.sh "$1"
}

# logException is used to log a user.crit error to the logger
logException() {
    echo "$1"
    logger -p 2 -s -t upgrade.sh "$1"
}

for f in /etc/os-release /tmp/sysinfo/board_name /etc/config/uid ; do
    if [ ! -f $f ] ; then
        logException "Missing $f file"
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
DEVICE="`grep DEVICE_MANUFACTURER_URL /etc/os-release | sed -rn 's/.*(mfw|sdwan)-(.*?)-Packages.*/\2/p'`"

# ash doesn't let us use ${!var} to determine variable values, so we need to do
# this eval echo hack to find out if the value of the arg is non-null
for ARG in VERSION FULL_VERSION BOARD UID DEVICE ; do
    VAL=$(eval echo \$$ARG)
    if [ -z "$VAL" ] ; then
        logException "Missing param for updates.untangle.com API call:  $ARG"
        exit 1
    fi
done

ARGS="version=${VERSION}&fullVersion=${FULL_VERSION}&board=${BOARD}&uid=${UID}"
URL="https://updates.untangle.com/api/v1/releases/${DEVICE}/latest?${ARGS}"
TRANSLATED_URL=$(wget -qO- "http://127.0.0.1/api/uri/geturiwithpath/uri=$URL")
if [ "$TRANSLATED_URL" != "" ] ; then
    URL=$TRANSLATED_URL
fi

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


logMessage "Checking for new releases with URL: ${URL}"

rm -f $OUTPUT

wget -t 5 --timeout=30 -q -O $OUTPUT $URL
if [ $? != 0 ] ; then
    logException "Failed to reach upgrade server."
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

if [ -z "$OUTPUT" ] || [ ! -s "$OUTPUT" ] ; then
    # no upgrade available
    logMessage "No upgrades available"
    exit 1
fi

json_init
json_load_file $OUTPUT
json_get_var NEWVER version
json_get_var IMAGEURL url

if [ -z "$NEWVER" ] ; then
    logException "Invalid response (no version found)"
    exit 1
fi
if [ -z "$IMAGEURL" ] ; then
    logException "Invalid response (no URL found)"
    exit 1
fi

logMessage
logMessage "Current version: ${VERSION}"
logMessage "Newest  version: ${NEWVER}"
logMessage

if [ $SIMULATE == 1 ] ; then
    logMessage "Upgrade available."
    # upgrade available
    exit 0
fi

logMessage "Downloading upgrade image..."
wget -t 5 --timeout=30 -q -O /tmp/sysupgrade.img $IMAGEURL
if [ $? != 0 ] ; then
    logException "Failed to download image."
    exit 1
fi

logMessage "Upgrading..."
logMessage

/sbin/sysupgrade /tmp/sysupgrade.img


