#! /bin/bash

set -e

# hides perl warning about locale
export LC_ALL=${LC_ALL:-C}

# functions
versionString() {
  ts=$(date +"%Y%m%dT%H%M")
  echo $(git describe --always --long)_${ts}
}

# CLI options
usage() {
  echo "$0 -o <outputDir>"
  echo "  -o <outputDir>"
}

BRANCH=""
OUTPUT_DIR=""
while getopts "ho:" opt ; do
  case "$opt" in
    o) OUTPUT_DIR="$OPTARG" ;;
    h) usage ; exit 0 ;;
  esac
done

if [ -z "$OUTPUT_DIR" ] ; then
  usage
  exit 1
fi

# main
mkdir -p $OUTPUT_DIR

find bin/targets -iregex '.+\(gz\|img\|vdi\|vmdk\|bin\|kmod-mac80211-hwsi.+ipk\)' | grep -v Packages.gz | while read f ; do
  b=$(basename "$f")
  newName=${b/./_$(versionString).}
  newName=${newName/-squashfs}
  newName=${newName/-mvebu-cortexa9}
  newName=${newName/.bin/.img}
  newName=${newName/mfw-/sdwan-}
  cp $f ${OUTPUT_DIR}/$newName
done
