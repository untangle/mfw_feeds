#! /bin/bash

set -e

usage() {
  echo "Usage: $0 [-d <device>] [-l <libc>] [-r <region>]"
  echo "  -d <device> : x86_64, wrt3200, ... (defaults to x86_64)"
  echo "  -l <libc>   : musl, glibc (defaults to musl)"
  echo "  -r <region> : us, eu (defaults to us)"
  exit 1
}

DEVICE="x86_64"
LIBC="musl"
REGION="us"
while getopts "d:l:r:h" opt ; do
  case "$opt" in
    d) DEVICE="$OPTARG" ;;
    l) LIBC="$OPTARG" ;;
    r) REGION="$OPTARG" ;;
    h) usage ;;
  esac
done

DIR=$(readlink -f $(dirname "$0"))

cat $DIR/{common/*,libc/$LIBC/*,device/$DEVICE/*,region/$REGION/*}
