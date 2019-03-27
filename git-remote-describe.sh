#! /bin/bash

set -x

REPO=$1
COMMITISH=$2

tmpDir=$(mktemp -d)

git clone -q $REPO ${tmpDir}/foo

pushd ${tmpDir}/foo > /dev/null
git describe --always $COMMITISH
popd > /dev/null

rm -fr ${tmpDir}
