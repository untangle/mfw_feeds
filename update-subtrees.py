#! /usr/bin/python3

import subprocess

SUBTREES = { 'build': 'git@github.com:untangle/mfw_build.git' }

branch = subprocess.getoutput('git symbolic-ref --short HEAD')

for directory, repository in SUBTREES.items():
  # FIXME: handle release branch as wwell
  cmd = 'git subtree pull --prefix={} {} {}'.format(directory, repository, branch)

  print('Updating {} from {}:{}'.format(directory, repository, branch))
  subprocess.call(cmd, shell=True)
