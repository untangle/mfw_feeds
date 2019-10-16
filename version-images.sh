#! /bin/bash

set -e

# hides perl warning about locale
export LC_ALL=${LC_ALL:-C}

# CLI options
usage() {
  echo "$0 -d <device> -o <outputDir> [-c] [-t <timestamp>]"
  echo "  -c             : start by cleaning output directory"
  echo "  -d <device>    : which device"
  echo "  -o <outputDir> : where store the renamed images "
  echo "  -t <timestamp> : optional; defaults to $(date +"%Y%m%dT%H%M")"
}

DEVICE=""
OUTPUT_DIR=""
START_CLEAN=""
TS=$(date +"%Y%m%dT%H%M")
while getopts "hcd:o:t:" opt ; do
  case "$opt" in
    c) START_CLEAN=1 ;;
    d) DEVICE="$OPTARG" ;;
    o) OUTPUT_DIR="$OPTARG" ;;
    t) TS="$OPTARG" ;;
    h) usage ; exit 0 ;;
  esac
done

if [ -z "$OUTPUT_DIR" ] || [ -z "$DEVICE" ] ; then
  usage
  exit 1
fi

# main
SHORT_VERSION="$(git describe --always --tags --abbrev=0)"
FULL_VERSION="$(git describe --always --tags --long)_${TS}"

case $DEVICE in
  wrt1900) DEVICE=wrt1900acs ;;
  wrt3200) DEVICE=wrt3200acm ;;
  x86_64) DEVICE=x86-64 ;;
esac

PACKAGES_FILE="sdwan-${DEVICE}-Packages_${FULL_VERSION}.txt"

[[ -z "$START_CLEAN" ]] || rm -fr $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

find bin/targets -iregex '.+\(gz\|img\|vdi\|vmdk\|bin\|kmod-mac80211-hwsi.+ipk\)' | grep -v Packages.gz | while read f ; do
  b=$(basename "$f")
  newName=${b/./_${FULL_VERSION}.}
  newName=${newName/-squashfs}
  newName=${newName/-mvebu-cortexa9}
  newName=${newName/-mvebu-cortexa53}
  newName=${newName/-linksys}
  newName=${newName/-turris}
  newName=${newName/_turris}
  newName=${newName/-globalscale}
  newName=${newName/-cznic}
  newName=${newName/-sdcard}
  newName=${newName/-v7-emmc}
  newName=${newName/.bin/.img}
  newName=${newName/mfw-/sdwan-}
  newName=${newName/mfw_/sdwan-}
  cp $f ${OUTPUT_DIR}/$newName
done

find ${OUTPUT_DIR} -iname "*esxi_v*.vmdk" | while read f ; do
  flat_b=$(basename "$f" | sed "s|esxi_v|esxi-flat_v|g")
  sed -i "s|FLAT \".*\"|FLAT \"$flat_b\"|g" $f
done

# add a list of MFW packages, with their versions
cp bin/packages/*/mfw/Packages ${OUTPUT_DIR}/${PACKAGES_FILE}

# also push that list to s3 (Jenkins should have the necessary AWS_*
# environment variables)
s3path="s3://download.untangle.com/sdwan/${SHORT_VERSION}/manifest/${PACKAGES_FILE}"
rc=1
for i in $(seq 1 5) ; do
  if s3cmd put bin/packages/*/mfw/Packages $s3path ; then
    rc=0
    break
  fi
done

exit $rc
