#! /bin/bash

set -e

## constants
GIT_BASE_URL="git@github.com:untangle/"
REPOSITORIES="bpfgen classd mfw_admin mfw_build mfw_feeds nft_dict packetd sync-settings openwrt"

## functions
clone() {
  repo=$1
  from=$2
  url="${GIT_BASE_URL}$repo"

  git clone --depth 2 -b $from $url
}

branch() {
  repo=$1
  simulate=$2

  pushd $repo
  git push $simulate origin HEAD:$BRANCH_NAME
  popd
}

## main
if [ $# -lt 2 ] ; then
  echo "Usage: $0 <branch-name> <from> <new-version> [simulate]"
fi

# CLI args
BRANCH_NAME=$1
FROM=$2
NEW_VERSION=$3
if [ -n "$4" ] ; then
  SIMULATE="-n"
fi

# tmp dir to clone everything
tmpDir=$(mktemp -d /tmp/mfw-branching-XXXXXXX)
pushd $tmpDir

# clone each repository
for repo in $REPOSITORIES ; do
  clone $repo $FROM
done

# in mfw_build, point to release branch for the feeds, and also update
# Jenkins triggers for the release branch
pushd mfw_build
perl -i -pe 's/(?<=mfw_feeds.git).*/;'$BRANCH_NAME'/' feeds.conf.mfw
git commit -a -m "Point to branch $BRANCH_NAME for mfw_feeds"
popd

# udpate subtree in openwrt
pushd openwrt
git checkout -b $BRANCH_NAME
git subtree pull --prefix=mfw -m 'Update mfw_build subtree as part of release branching' $tmpDir/mfw_build $FROM
popd

# branch each repository
for repo in $REPOSITORIES ; do
  branch $repo $SIMULATE
done

# update version in master
if [[ -n "$NEW_VERSION" ]] ; then
  pushd openwrt
  git checkout origin/master
  git tag -a -m "Release branching: new version is ${NEW_VERSION}" $NEW_VERSION
  git push --tags $SIMULATE
  popd
fi

# exit tmpDir and remove i t
popd
rm -rf "${tmpDir}"
