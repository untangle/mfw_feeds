#! /bin/bash

set -e
#set -x

usage() {
  echo "Usage: $0 [-d <device>] [-l <libc>] [-v (latest|<branch>|<tag>)]"
  echo "  -d <device>              : x86_64, wrt3200, wrt1900 (defaults to x86_64)"
  echo "  -l <libc>                : musl, glibc (defaults to musl)"
  echo "  -v latest|<branch>|<tag> : version to build from (defaults to latest)"
  echo "                             - 'latest' is a special keyword meaning 'tip of each master branch'"
  echo "                             - <branch> or <tag> can be any valid git object as long as it exists"
  echo "                               in each package's source repository (mfw_admin, packetd, ngfw_pkgs, etc)"
  exit 1
}

DEVICE="x86_64"
LIBC="musl"
VERSION="master"
while getopts "d:l:v:h" opt ; do
  case "$opt" in
    d) DEVICE="$OPTARG" ;;
    l) LIBC="$OPTARG" ;;
    v) VERSION="$OPTARG" ;;
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
make ${@:--j32} UNTANGLE_VERSION=${VERSION} download

# build
make ${@:--j32}
