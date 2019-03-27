#! /bin/bash

REPO=$1
BRANCH=$2

tmpDir=$(mktemp -d)

git clone -q -b $BRANCH $REPO ${tmpDir}/foo

pushd ${tmpDir}/foo > /dev/null
git describe --always --long
popd > /dev/null

rm -fr ${tmpDir}
