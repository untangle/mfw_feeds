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
VERSION_STRING="$(git describe --always --long --tags)_${TS}"
PACKAGES_FILE="sdwan-${DEVICE}-Packages_${VERSION_STRING}.txt"

[[ -z "$START_CLEAN" ]] || rm -fr $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

find bin/targets -iregex '.+\(gz\|img\|vdi\|vmdk\|bin\|kmod-mac80211-hwsi.+ipk\)' | grep -v Packages.gz | while read f ; do
  b=$(basename "$f")
  newName=${b/./_${VERSION_STRING}.}
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

# add a list of MFW packages, with their versions
cp bin/packages/*/mfw/Packages ${OUTPUT_DIR}/${PACKAGES_FILE}

# also push that list to s3 (Jenkins should have the necessary AWS_*
# environment variables)
s3cmd put bin/packages/*/mfw/Packages s3://download.untangle.com/sdwan/manifest/${PACKAGES_FILE}
