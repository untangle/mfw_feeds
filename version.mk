MFW_VERSION ?= $(shell git ls-remote --refs --tags $(1) | tail -n 1 | sed -e 's|.*/||')
MFW_COMMIT = $(shell git ls-remote --refs $(1) refs/heads/$(2) refs/tags/$(2) | cut -f 1)

# allow the user to force a specific URL or version, per package
#
# for instance one could declare PKG_SOURCE_URL_packetd,
# PKG_SOURCE_VERSION_classd, etc
check-var-overridden = $(if $($(1)_$(PKG_NAME)),$($(1)_$(PKG_NAME)),$(2))
PKG_SOURCE_URL := $(call check-var-overridden,PKG_SOURCE_URL,$(PKG_SOURCE_URL))
PKG_SOURCE_VERSION := $(call check-var-overridden,PKG_SOURCE_VERSION,$(call MFW_VERSION,$(PKG_SOURCE_URL)))

PKG_VERSION := $(call MFW_COMMIT,$(PKG_SOURCE_URL),$(PKG_SOURCE_VERSION))

PKG_SOURCE_SUBDIR := $(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE := $(PKG_NAME)-$(PKG_SOURCE_VERSION)-$(PKG_VERSION).tar.xz

all:
	echo $(PKG_NAME)
	echo $(PKG_SOURCE_URL)
	echo $(PKG_SOURCE_VERSION)
	echo $(PKG_VERSION)
