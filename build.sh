#! /bin/bash

set -e
set -x

LIBC="musl"
if [ -n "$1" ] ; then
  LIBC=$1
  shift
fi

# add Untangle feed definitions
cp feeds.conf.untangle feeds.conf

# install feeds
./scripts/feeds update -a
./scripts/feeds install -a -p untangle

# config
cp feeds/untangle/configs/config.seed.x86.${LIBC} .config
make defconfig

# download
make ${@:-j32} download

# build
make ${@:-j32}
