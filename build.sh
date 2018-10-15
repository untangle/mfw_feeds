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
  echo "  -c                       : start clean"
  echo "  -v latest|<branch>|<tag> : version to build from (defaults to master)"
  echo "                             - 'release' is a special keyword meaning 'most recent tag from each"
  echo "                               package's source repository'"
  echo "                             - <branch> or <tag> can be any valid git object as long as it exists"
  echo "                               in each package's source repository (mfw_admin, packetd, ngfw_pkgs, etc)"
  exit 1
}

START_CLEAN=""
DEVICE="x86_64"
LIBC="musl"
VERSION="master"
MAKE_OPTIONS="-j32"
while getopts "cd:l:v:h:m:" opt ; do
  case "$opt" in
    c) START_CLEAN="y" ;;
    d) DEVICE="$OPTARG" ;;
    l) LIBC="$OPTARG" ;;
    v) VERSION="$OPTARG"
       [[ $VERSION == "release" ]] && VERSION="" ;;
    m) MAKE_OPTIONS="$OPTARG" ;;
    h) usage ;;
  esac
done

# add MFW feed definitions, and for each feed use the same branch
# we're currently on
CURRENT_BRANCH=$(git symbolic-ref --short HEAD 2> /dev/null || true)
if [ -n "$CURRENT_BRANCH" ] ; then
  perl -pe 's|$|;'${CURRENT_BRANCH}'| unless m/;/' feeds.conf.mfw >| feeds.conf
else
  cp feeds.conf.mfw feeds.conf
fi

# install feeds
rm -fr {.,package}/feeds/untangle*
./scripts/feeds update -a
./scripts/feeds install -a -p packages
./scripts/feeds install -a -p mfw

# config
./feeds/mfw/configs/generate.sh -d $DEVICE -l $LIBC >| .config
make defconfig

# start clean ?
[[ -z "$START_CLEAN" ]] || make $MAKE_OPTIONS clean

# download
make $MAKE_OPTIONS MFW_VERSION=${VERSION} download

# build
make $MAKE_OPTIONS MFW_VERSION=${VERSION}
