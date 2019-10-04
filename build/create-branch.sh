#! /bin/bash

set -e

## constants
GIT_BASE_URL="git@github.com:untangle/"
REPOSITORIES="classd mfw_admin mfw_build mfw_feeds nft_dict packetd sync-settings openwrt"

## functions
branch() {
  repo=$1
  simulate=$2

  url="${GIT_BASE_URL}$repo"

  git clone -b master $url
  pushd $repo
  git push $simulate origin master:$BRANCH_NAME
  popd
}

## main
if [ $# -lt 2 ] ; then
  echo "Usage: $0 <branch-name> <new-version> [simulate]"
fi

# CLI args
BRANCH_NAME=$1
NEW_VERSION=$2
if [ -n "$3" ] ; then
  SIMULATE="-n"
fi

# tmp dir to clone everything
tmpDir=$(mktemp -d /tmp/mfw-branching-XXXXXXX)
pushd $tmpDir

# new branch for each repository
for repo in $REPOSITORIES ; do
  branch $repo $SIMULATE
done

pushd openwrt
git tag -a -m "Release branching: new version is ${NEW_VERSION}" $NEW_VERSION
git push --tags $SIMULATE
popd

popd
rm -rf "${tmpDir}"
