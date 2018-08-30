MFW_VERSION ?= $(shell git ls-remote --refs --tags $(1) | awk -F/ '!/\^\{\}$$/ {a=$$3} END {print a}')
MFW_COMMIT = $(shell git ls-remote --refs $(1) $(2) | awk '{print substr($$1, 1, 8)}')

PKG_SOURCE_VERSION = $(call MFW_VERSION,$(PKG_SOURCE_URL))
PKG_VERSION = $(call MFW_COMMIT,$(PKG_SOURCE_URL),$(PKG_SOURCE_VERSION))

PKG_SOURCE_SUBDIR = $(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE = $(PKG_NAME)-$(PKG_SOURCE_VERSION)-$(PKG_VERSION).tar.xz
