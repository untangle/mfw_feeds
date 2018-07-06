#! /bin/bash

set -e

usage() {
  echo "Usage: $0 -d <device> [-l <libc>]"
  echo "  -d <device> : x86_64, wrt3200, ..."
  echo "  -l <libc>   : musl, glibc (defaults to musl)"
  exit 1
}

LIBC="musl"
while getopts "d:l:h" opt ; do
  case "$opt" in
    d) DEVICE="$OPTARG" ;;
    l) LIBC="$OPTARG" ;;
    h) usage ;;
  esac
done

if [ -z "$DEVICE" ] ; then
  usage
fi

DIR=$(readlink -f $(dirname "$0"))

cat $DIR/{common/*,libc/$LIBC/*,device/$DEVICE/*}
