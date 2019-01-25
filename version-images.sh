#! /bin/bash

set -e

# hides perl warning about locale
export LC_ALL=${LC_ALL:-C}

# functions
versionString() {
  ts=$(date +"%Y%m%dT%H%M")
  echo ${BRANCH}_${ts}
}

# CLI options
usage() {
  echo "$0 -b <branch> -d <device> -o <outputDir> [-l <libc>]"
  echo "  -b <branch>"
  echo "  -d <device>               : x86_64, omnia, wrt3200, wrt1900"
  echo "  -l <libc>                 : musl, glibc (defaults to musl)"
  echo "  -o <outputDir>"
}

BRANCH=""
DEVICE=""
LIBC="musl"
OUTPUT_DIR=""
while getopts "hb:d:l:o:" opt ; do
  case "$opt" in
    b) BRANCH="$OPTARG" ;;
    d) DEVICE="$OPTARG" ;;
    l) LIBC="$OPTARG" ;;
    o) OUTPUT_DIR="$OPTARG" ;;
    h) usage ; exit 0 ;;
  esac
done

if [ -z "$BRANCH" -o -z "$DEVICE" -o -z "$OUTPUT_DIR" ] ; then
  usage
  exit 1
fi

# main
mkdir -p $OUTPUT_DIR

find bin/targets -iregex '.+\(gz\|img\|bin\|kmod-mac80211-hwsi.+ipk\)' | while read f ; do
  b=$(basename "$f")
  cp $f ${OUTPUT_DIR}/${b/./_$(versionString).}
done
