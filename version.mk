ifeq ($(LOCAL_SOURCE_PATH),)
MFW_VERSION ?= $(shell git ls-remote --refs --tags $(1) | tail -n 1 | sed -e 's|.*/||')
MFW_COMMIT = $(shell git ls-remote --refs $(1) refs/heads/$(2) refs/tags/$(2) | cut -f 1)

# allow the user to force a specific URL or version, per package
#
# for instance one could declare PKG_SOURCE_URL_packetd,
# PKG_SOURCE_VERSION_classd, PKG_SOURCE_URL_sync_settings, etc
PKG_NAME_NO_DASH = $(subst -,_,$(PKG_NAME))
check-var-overridden = $(if $($(1)_$(PKG_NAME_NO_DASH)),$($(1)_$(PKG_NAME_NO_DASH)),$(2))
PKG_SOURCE_URL := $(call check-var-overridden,PKG_SOURCE_URL,$(PKG_SOURCE_URL))
PKG_SOURCE_VERSION := $(call check-var-overridden,PKG_SOURCE_VERSION,$(call MFW_VERSION,$(PKG_SOURCE_URL)))

PKG_VERSION := $(call MFW_COMMIT,$(PKG_SOURCE_URL),$(PKG_SOURCE_VERSION))
# use historical "go mod vendor" approach
export MFW_GOFLAGS="-mod=vendor"
else # use source tree already checked out on disk
USE_SOURCE_DIR := $(LOCAL_SOURCE_PATH)/$(subst git@,,$(subst :,/,$(subst .git,,$(PKG_SOURCE_URL))))
PKG_VERSION := local
# undefine those 2 so there is no fetch attempt
undefine PKG_SOURCE_PROTO
undefine PKG_SOURCE_URL
# use go modules already present on disk
export MFW_GOFLAGS="-mod=readonly"
endif

PKG_SOURCE_SUBDIR := $(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE := $(PKG_NAME)-$(PKG_SOURCE_VERSION)-$(PKG_VERSION).tar.xz

# this target is meant for testing
test-mfw-version:
	@echo "PKG_NAME: $(PKG_NAME)"
	@echo "PKG_NAME_NO_DASH: $(PKG_NAME_NO_DASH)"
	@echo "PKG_SOURCE_PROTO: $(PKG_SOURCE_PROTO)"
	@echo "PKG_SOURCE_URL: $(PKG_SOURCE_URL)"
	@echo "USE_SOURCE_DIR: $(USE_SOURCE_DIR)"
	@echo "PKG_SOURCE_VERSION: $(PKG_SOURCE_VERSION)"
	@echo "PKG_VERSION: $(PKG_VERSION)"
