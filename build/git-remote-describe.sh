#! /bin/bash

set -x

REPO=$1
COMMITISH=$2

tmpDir=$(mktemp -d)

git clone -q $REPO ${tmpDir}

pushd ${tmpDir} > /dev/null
git describe --always origin/$COMMITISH
popd > /dev/null

rm -fr ${tmpDir}
