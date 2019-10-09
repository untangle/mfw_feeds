#! /bin/bash

set -e

## constants
GIT_BASE_URL="git@github.com:untangle/"
REPOSITORIES="classd mfw_admin mfw_build mfw_feeds nft_dict packetd sync-settings openwrt"

## functions
clone() {
  repo=$1
  url="${GIT_BASE_URL}$repo"

  git clone -b master $url
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

# clone each repository
for repo in $REPOSITORIES ; do
  clone $repo
done

# in mfw_build, point to release branch for the feeds, and also update
# Jenkins triggers for the release branch
pushd mfw_build
perl -i -pe 's/(?<=mfw_feeds.git).*/;'$BRANCH_NAME'/' feeds.conf.mfw
git commit -a -m "Point to branch $BRANCH_NAME for mfw_feeds"
perl -i -pe 's|/master|/'$BRANCH_NAME'|g if m/upstreamProjects:/' Jenkinsfile
git commit -a -m "Update jenkins triggers to branch $BRANCH_NAME"
popd

# udpate subtree in openwrt
pushd openwrt
git checkout -b $BRANCH_NAME
git subtree pull --prefix=mfw -m 'Update mfw_build subtree as part of release branching' $tmpDir/mfw_build master
popd

# branch each repository
for repo in $REPOSITORIES ; do
  branch $repo $SIMULATE
done

# update version in master
pushd openwrt
git checkout master
git tag -a -m "Release branching: new version is ${NEW_VERSION}" $NEW_VERSION
git push --tags $SIMULATE
popd

# exit tmpDir and remove i t
popd
rm -rf "${tmpDir}"
