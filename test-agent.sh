#! /bin/bash

set -e
set -x

MFW_HOST="mfw"

# FIXME
sleep 5

# # test SSH connectivity
# nc -z $MFW_HOST 22

# # test classd connectivity
# nc -z $MFW_HOST 8123

# # test webui connectivity
# echo foo | curl http://$MFW_HOST

ping -c 1 $MFW_HOST
