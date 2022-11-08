#! /bin/bash

set -e

usage() {
  echo "Usage: $0 [-d <device>] [-l <libc>] [-r <region>] [-u]"
  echo "  -d <device> : x86_64, wrt3200, ... (defaults to x86_64)"
  echo "  -l <libc>   : musl, glibc (defaults to musl)"
  echo "  -r <region> : us, eu (defaults to us)"
  echo "  -u          : 'upstream' build, with our general config but no MFW packages"
  exit 1
}
TEMP=$(getopt -o d:l:uhr: --long device:,libc:,region:,with-dpdk)
eval set -- "$TEMP"
DEVICE="x86_64"
LIBC="musl"
REGION="us"
NO_MFW_PACKAGES=""
while getopts "d:l:r:uh" opt ; do
  case "$opt" in
    -d | --device ) DEVICE="$OPTARG" ;;
    -l | --libc ) LIBC="$OPTARG" ;;
    -r | --region ) REGION="$OPTARG" ;;
    -u | --upstream ) NO_MFW_PACKAGES="1" ;;
    --with-dpdk ) WITH_DPDK=1 ;;
    -h ) usage ;;
  esac
done

DIR=$(readlink -f $(dirname "$0"))

for f in $DIR/{common/*,libc/$LIBC/*,device/$DEVICE/*,region/$REGION/*} ; do
  if [[ -n "$NO_MFW_PACKAGES" ]] && [[ $f =~ "/mfw_packages" ]] ; then
    continue
  fi
  cat $f
done

if [ -n "$WITH_DPDK" ]
then
    for f in $DIR/dpdk/*
    do
	cat $f
    done
fi
