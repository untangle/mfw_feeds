#! /bin/bash

set -x

REPO=$1
COMMITISH=$2

git ls-remote --refs $REPO refs/heads/$COMMITISH refs/tags/$COMMITISH | awk '{print $1}'
