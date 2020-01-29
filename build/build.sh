#! /bin/bash -x

set -e

# hides perl warning about locale
export LC_ALL=${LC_ALL:-C}

# make sure the time conversion from epoch format to human-readable
# one uses HQ timezone
export TZ="America/Los_Angeles"

usage() {
  echo "Usage: $0 [-d <device>] [-l <libc>] [-v (latest|<branch>|<tag>)] [-c (false|true)]"
  echo "  -d <device>               : x86_64, omnia, wrt3200, wrt1900, wrt32x, espressobin (defaults to x86_64)"
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
VERSION_FILE="version"
cleanup() {
  git checkout -- ${VERSION_FILE} ${VERSION_DATE_FILE}
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
    v) VERSION="$OPTARG" ;;
    m) MAKE_OPTIONS="$OPTARG" ;;
    h) usage ; exit 0 ;;
  esac
done

# main
trap cleanup ERR INT
CURDIR=$(dirname $(readlink -f $0))

# grab github.com's ssh key, and check ssh-agent;
# this is needed for private repositories (see MFW-877)
mkdir -p ~/.ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts
ssh-add -l

# set MFW_VERSION, or not; this looks convoluted, but ?= in Makefiles
# doesn't work if the variable is defined but empty
if [[ $VERSION == "release" ]] ; then
  VERSION_ASSIGN=""
else
  VERSION_ASSIGN="MFW_VERSION=${VERSION}"
fi

# start clean only if explicitely requested
case $START_CLEAN in
  false|0) : ;;
  *) [ -f .config ] || make defconfig
     make $MAKE_OPTIONS clean
     rm -fr build_dir staging_dir ;;
esac

# set timestamp for files
SOURCE_DATE_EPOCH=$(date +"%s")
echo $SOURCE_DATE_EPOCH >| ${VERSION_DATE_FILE}
# also save it, as a readable format, in a file that won't be cleaned
# up once the build is finished, so post-build process like artifact
# archiving, etc can still access it
SOURCE_DATE=$(date -d @$SOURCE_DATE_EPOCH +%Y%m%dT%H%M)
mkdir -p tmp
echo $SOURCE_DATE >| tmp/${VERSION_DATE_FILE}

# add MFW feed definitions
cp ${CURDIR}/feeds.conf.mfw feeds.conf

# install feeds
rm -fr {.,package}/feeds/untangle*
./scripts/feeds update -a
./scripts/feeds install -a -p packages
if [ -d ./feeds/mfw/golang ] ; then
  # prioritize golang from mfw over official OpenWrt packages
  for pkg in golang golang-doc golang-src ; do
    ./scripts/feeds uninstall $pkg
  done
fi
./scripts/feeds install -a -f -p mfw

# config
./feeds/mfw/configs/generate.sh -d $DEVICE -l $LIBC >| .config
make defconfig

## versioning
# static
# FIXME: move those to feeds' config once stable and agreed upon
cat >> .config <<EOF
CONFIG_VERSION_DIST="MFW"
CONFIG_VERSION_MANUFACTURER="Untangle"
CONFIG_VERSION_BUG_URL="https://jira.untangle.com/projects/MFW/"
CONFIG_VERSION_HOME_URL="https://github.com/untangle/mfw_feeds"
CONFIG_VERSION_SUPPORT_URL="https://forums.untangle.com"
CONFIG_VERSION_PRODUCT="MFW"
EOF

# dynamic
openwrtVersion="$(git describe --tags --abbrev=0 --match 'v[0-9][0-9].[0-9][0-9]*' | sed -e 's/^v//')"
mfwVersion="$(git describe --always --tags --long)"
mfwShortVersion="$(git describe --always --tags --abbrev=0)"
echo CONFIG_VERSION_CODE="$openwrtVersion" >> .config
echo CONFIG_VERSION_NUMBER="$mfwVersion" >> .config
echo $mfwVersion >| $VERSION_FILE
if [ -n "$BUILD_URL" ] ; then # Jenkins build
  # adjust device name to match exact OpenWrt specification
  case $DEVICE in
    wrt1900) DEVICE=wrt1900acs ;;
    wrt3200) DEVICE=wrt3200acm ;;
    x86_64) DEVICE=x86-64 ;;
  esac
  packagesList="sdwan-${DEVICE}-Packages_${mfwVersion}_${SOURCE_DATE}.txt"
  echo CONFIG_VERSION_MANUFACTURER_URL="https://downloads.untangle.com/public/sdwan/${mfwShortVersion}/manifest/${packagesList}" >> .config
else
  echo CONFIG_VERSION_MANUFACTURER_URL="developer build" >> .config
fi

# download
make $MAKE_OPTIONS $VERSION_ASSIGN download

# build
if ! make $MAKE_OPTIONS $VERSION_ASSIGN ; then
  make -j1 V=s $VERSION_ASSIGN
fi

cleanup
