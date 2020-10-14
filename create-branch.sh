#! /bin/bash

set -e

## constants
GIT_BASE_URL="git@github.com:untangle/"
REPOSITORIES="bpfgen classd mfw_admin mfw_build mfw_feeds nft_dict packetd sync-settings openwrt"

## functions
help() {
  echo "$0 <new_branch> <from_branch> <new_version> [simulate]"
  echo "for instance:"
  echo "  '$0 release-3.0 master 3.1' creates a 3.0 branch from master, and sets master to be 3.1"
  echo "  '$0 release-4.1 release-4.0 ""' creates a 4.1 branch from release-4.0, without changing the version in release-4.0"
}

clone() {
  repo=$1
  from=$2
  url="${GIT_BASE_URL}$repo"

  git clone --depth 10 -b $from $url
}

branch() {
  repo=$1
  simulate=$2

  pushd $repo
  git push $simulate origin HEAD:$BRANCH_NAME
  popd
}

## main

# CLI args
if [ $# -lt 3 ] || [ $# -gt 4 ] ; then
  help
  exit 1
fi

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
