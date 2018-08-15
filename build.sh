#! /bin/bash

set -e
set -x

usage() {
  echo "Usage: $0 [-d <device>] [-l <libc>]"
  echo "  -d <device> : x86_64, wrt3200, ... (defaults to x86_64)"
  echo "  -l <libc>   : musl, glibc (defaults to musl)"
  exit 1
}

DEVICE="x86_64"
LIBC="musl"
while getopts "d:l:h" opt ; do
  case "$opt" in
    d) DEVICE="$OPTARG" ;;
    l) LIBC="$OPTARG" ;;
    h) usage ;;
  esac
done
shift $(($OPTIND - 1))

# add Untangle feed definitions
cp feeds.conf.untangle feeds.conf

# install feeds
./scripts/feeds update -a
./scripts/feeds install -a -p packages
./scripts/feeds install -a -p untangle

# config
./feeds/untangle/configs/generate.sh -d $DEVICE -l $LIBC >| .config
make defconfig

# download
make ${@:--j32} download

# build
make ${@:--j32}
