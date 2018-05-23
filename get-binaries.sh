#! /bin/bash

MIRROR="http://updates.untangle.com/openwrt"
PACKETD_DIR="packetd/src"
PACKETD_NAME="packetd"

LIBNAVL_DIR=libnavl/src
LIBNAVL_NAME=libnavl.so.4.5

mkdir -p ${PACKETD_DIR}
curl -s -o ${PACKETD_DIR}/${PACKETD_NAME} ${MIRROR}/${PACKETD_NAME}
chmod 755 ${PACKETD_DIR}/${PACKETD_NAME}

mkdir -p ${LIBNAVL_DIR}
curl -s -o ${LIBNAVL_DIR}/${LIBNAVL_NAME} ${MIRROR}/${LIBNAVL_NAME}
chmod 755 ${LIBNAVL_DIR}/${LIBNAVL_NAME}
