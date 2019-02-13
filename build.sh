#! /bin/bash -x

set -e

# hides perl warning about locale
export LC_ALL=${LC_ALL:-C}

usage() {
  echo "Usage: $0 [-d <device>] [-l <libc>] [-v (latest|<branch>|<tag>)] [-c (false|true)]"
  echo "  -d <device>               : x86_64, omnia, wrt3200, wrt1900 (defaults to x86_64)"
  echo "  -l <libc>                 : musl, glibc (defaults to musl)"
  echo "  -m <make options>         : pass those to OpenWRT's make \"as is\" (default is -j32)"
  echo "  -c true|false             : start clean or not (default is false, meaning \"do not start clean\""
  echo "  -v release|<branch>|<tag> : version to build from (defaults to master)"
  echo "                              - 'release' is a special keyword meaning 'most recent tag from each"
  echo "                                package's source repository'"
  echo "                              - <branch> or <tag> can be any valid git object as long as it exists"
  echo "                                in each package's source repository (mfw_admin, packetd, etc)"
}

# cleanup
VERSION_DATE_FILE="version.date"
cleanup() {
  git checkout -- ${VERSION_DATE_FILE}
}

config() {
  ./feeds/mfw/configs/generate.sh -d $DEVICE -l $LIBC >| .config
  make defconfig
}

# CLI options
START_CLEAN="false"
DEVICE="x86_64"
LIBC="musl"
VERSION="master"
MAKE_OPTIONS="-j32"
while getopts "hc:d:l:v:m:" opt ; do
  case "$opt" in
    c) START_CLEAN="$OPTARG" ;;
    d) DEVICE="$OPTARG" ;;
    l) LIBC="$OPTARG" ;;
    v) VERSION="$OPTARG"
       [[ $VERSION == "release" ]] && VERSION="" ;;
    m) MAKE_OPTIONS="$OPTARG" ;;
    h) usage ; exit 0 ;;
  esac
done

# main
trap cleanup ERR INT
CURDIR=$(dirname $(readlink -f $0))

# start clean only if explicitely requested
case $START_CLEAN in
  false|0) : ;;
  *) [ -f .config ] || config
     make $MAKE_OPTIONS clean
     rm -fr build_dir staging_dir ;;
esac

# set timestamp for files
date +"%s" >| ${VERSION_DATE_FILE}
export SOURCE_DATE_EPOCH=$(cat ${VERSION_DATE_FILE})

# add MFW feed definitions
cp ${CURDIR}/feeds.conf.mfw feeds.conf

# install feeds
rm -fr {.,package}/feeds/untangle*
./scripts/feeds update -a
./scripts/feeds install -a -p packages
./scripts/feeds install -a -f -p mfw

# config
config

# download
make $MAKE_OPTIONS MFW_VERSION=${VERSION} download

# build
if ! make $MAKE_OPTIONS MFW_VERSION=${VERSION} ; then
  make -j1 V=s MFW_VERSION=${VERSION}
fi

cleanup
