#!/bin/sh

usage() {
    echo "Usage: $0 <options>"
    echo "Options: "
    exit 1;
}

for f in /etc/os-release /tmp/sysinfo/board_name /etc/config/uid ; do
    if [ ! -f $f ] ; then
        echo "Missing $f file"
        exit 1
    fi
done

VERSION="`grep VERSION_ID /etc/os-release | sed -rn 's/.*v(\d{1,2}\.\d{1,2}\.?\d{0,2}).*/\1/p'`"
BOARD="`cat /tmp/sysinfo/board_name | tr -d '[ \t\r\n]'`"

if [[ -f "/tmp/sysinfo/untangle_board_name" ]] ; then
    BOARD="`cat /tmp/sysinfo/untangle_board_name | tr -d '[ \t\r\n]'`"
fi

UID="`cat /etc/config/uid | tr -d '[ \t\r\n]'`"
DEVICE="`grep LEDE_DEVICE_MANUFACTURER_URL /etc/os-release | sed -rn 's/.*sdwan-(.*?)-Packages.*/\1/p'`"

ARGS="version=${VERSION}&device=${DEVICE}&uid=${UID}"
URL="https://license.untangle.com/license.php?action=getLicenses&${ARGS}"
OUTPUT="/tmp/licenses.json"
SIMULATE=0
FILE="/etc/config/licenses.json"

if test "${BOARD#*linksys*}" != "$BOARD" || test "${BOARD#*virtualbox*}" != "$BOARD" ; then
    cat > $FILE <<'EOF'
{
    "javaClass": "java.util.LinkedList",
    "list": [
        {
            "name": "untangle-node-throughput",
            "seats": 1000000
        }
    ]
}
EOF

else
    echo "Downloading licenses from $URL... "
    rm -f $OUTPUT

    wget -t 5 --timeout=30 -q -O $OUTPUT $URL
    if [ $? != 0 ] ; then
        echo "Failed to download licenses ($?)."
        exit 1
    else
        echo "Saving licenses in $FILE"
        cp $OUTPUT $FILE
    fi
fi

# rerun our qos scripts to sync license limit
/etc/init.d/qos restart






