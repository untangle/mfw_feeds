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
VERSION_STRING="$(git describe --always --long)_${TS}"

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
