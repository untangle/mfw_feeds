MFW_VERSION ?= $(shell git ls-remote --refs --tags $(1) | tail -n 1 | sed -e 's|.*/||')
MFW_COMMIT = $(shell git ls-remote --refs $(1) refs/heads/$(2) refs/tags/$(2) | cut -f 1)

PKG_SOURCE_VERSION ?= $(call MFW_VERSION,$(PKG_SOURCE_URL))
PKG_VERSION := $(call MFW_COMMIT,$(PKG_SOURCE_URL),$(PKG_SOURCE_VERSION))

PKG_SOURCE_SUBDIR := $(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE := $(PKG_NAME)-$(PKG_SOURCE_VERSION)-$(PKG_VERSION).tar.xz
