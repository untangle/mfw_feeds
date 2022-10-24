#! /bin/bash

set -e

usage() {
  echo "Usage: $0 [-d <device>] [-l <libc>] [-r <region>] [-u]"
  echo "  -d <device> : x86_64, wrt3200, ... (defaults to x86_64)"
  echo "  -l <libc>   : musl, glibc (defaults to musl)"
  echo "  -r <region> : us, eu (defaults to us)"
  echo "  -r <region> : us, eu (defaults to us)"
  echo "  -u          : 'upstream' build, with our general config but no MFW packages"
  exit 1
}

DEVICE="x86_64"
LIBC="musl"
REGION="us"
NO_MFW_PACKAGES=""
while getopts "d:l:r:uh" opt ; do
  case "$opt" in
    d) DEVICE="$OPTARG" ;;
    l) LIBC="$OPTARG" ;;
    r) REGION="$OPTARG" ;;
    u) NO_MFW_PACKAGES="1" ;;
    h) usage ;;
  esac
done

DIR=$(readlink -f $(dirname "$0"))

for f in $DIR/{common/*,libc/$LIBC/*,device/$DEVICE/*,region/$REGION/*} ; do
  if [[ -n "$NO_MFW_PACKAGES" ]] && [[ $f =~ "/mfw_packages" ]] ; then
    continue
  fi
  cat $f
done
