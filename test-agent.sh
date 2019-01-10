#! /bin/bash

set -e

MFW_HOST="mfw"

# FIXME
sleep 5

# test SSH connectivity
nc $MFW_HOST 22

# test classd connectivity
nc $MFW_HOST 8080

# test webui connectivity
curl http://$MFW_HOST
