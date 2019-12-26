#! /bin/bash

set -x

REPO=$1

git ls-remote --refs --tags $REPO | awk -F/ '!/\^\{\}$/ {a=$3} END {print a}'
