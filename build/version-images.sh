#! /bin/bash

set -e

# hides perl warning about locale
export LC_ALL=${LC_ALL:-C}

# timestamp
TS=$(date +"%Y%m%dT%H%M")
VERSION_STRING="$(git describe --always --long)_${TS}"

# CLI options
usage() {
  echo "$0 -d <device> -o <outputDir> [-c]"
  echo "  -c             : start by cleaning output directory"
  echo "  -d <device>    : which device"
  echo "  -o <outputDir> : where store the renamed images "
}

DEVICE=""
OUTPUT_DIR=""
START_CLEAN=""
while getopts "hcd:o:" opt ; do
  case "$opt" in
    c) START_CLEAN=1 ;;
    d) DEVICE="$OPTARG" ;;
    o) OUTPUT_DIR="$OPTARG" ;;
    h) usage ; exit 0 ;;
  esac
done

if [ -z "$OUTPUT_DIR" ] || [ -z "$DEVICE" ] ; then
  usage
  exit 1
fi

# main
[[ -z "$START_CLEAN" ]] || rm -fr $OUTPUT_DIR
mkdir -p $OUTPUT_DIR

find bin/targets -iregex '.+\(gz\|img\|vdi\|vmdk\|bin\|kmod-mac80211-hwsi.+ipk\)' | grep -v Packages.gz | while read f ; do
  b=$(basename "$f")
  newName=${b/./_${VERSION_STRING}.}
  newName=${newName/-squashfs}
  newName=${newName/-mvebu-cortexa9}
  newName=${newName/-linksys}
  newName=${newName/-turris}
  newName=${newName/.bin/.img}
  newName=${newName/mfw-/sdwan-}
  cp $f ${OUTPUT_DIR}/$newName
done

# add a list of MFW packages, with their versions
cp bin/packages/*/mfw/Packages ${OUTPUT_DIR}/sdwan-${DEVICE}-Packages_${VERSION_STRING}.txt
