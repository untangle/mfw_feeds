#! /bin/bash

set -e
#set -x

# hides perl warning about locale
export LC_ALL=${LC_ALL:-C}

usage() {
  echo "Usage: $0 [-d <device>] [-l <libc>] [-v (latest|<branch>|<tag>)]"
  echo "  -d <device>              : x86_64, wrt3200, wrt1900 (defaults to x86_64)"
  echo "  -l <libc>                : musl, glibc (defaults to musl)"
  echo "  -m <make options>        : pass those to OpenWRT's make \"as is\" (default is -j32)"
  echo "  -v latest|<branch>|<tag> : version to build from (defaults to master)"
  echo "                             - 'release' is a special keyword meaning 'most recent tag from each"
  echo "                                package's source repository'"
  echo "                             - <branch> or <tag> can be any valid git object as long as it exists"
  echo "                               in each package's source repository (mfw_admin, packetd, ngfw_pkgs, etc)"
  exit 1
}

DEVICE="x86_64"
LIBC="musl"
VERSION="master"
MAKE_OPTIONS="-j32"
while getopts "d:l:v:h:m:" opt ; do
  case "$opt" in
    d) DEVICE="$OPTARG" ;;
    l) LIBC="$OPTARG" ;;
    v) VERSION="$OPTARG"
       [[ $VERSION == "release" ]] && VERSION="" ;;
    m) MAKE_OPTIONS="$OPTARG" ;;
    h) usage ;;
  esac
done

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
make $MAKE_OPTIONS UNTANGLE_VERSION=${VERSION} download

# build
make $MAKE_OPTIONS UNTANGLE_VERSION=${VERSION}
