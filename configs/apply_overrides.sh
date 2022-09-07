#! /bin/bash
#
# We can override core packages by adding a new directory under
# ours with the changes we want (and new makefile, etc) but 
# this does not work for other feeds like "packages" for example.
#
# In fact, trying to do the recommended method of making a new directory
# and attempting to override via updates Makefile, directories, does 
# not work without some tremendously...."creativity" and many, many
# hours trying to make it work.
#
# This is simple:  Under overrides/ specify your tree into packages,
# add whatever files you need to add or overwrite and you're good to go.
#
echo "Apply overrides to ./feeds"
rsync -r ./feeds/mfw/configs/overrides/* ./feeds
