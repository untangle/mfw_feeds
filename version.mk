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
export MFW_GOFLAGS="-mod=vendor -buildvcs=false"
else # use source tree already checked out on disk
PKG_SOURCE_PATH := $(subst git@,,$(subst :,/,$(subst .git,,$(PKG_SOURCE_URL))))
USE_SOURCE_DIR := $(LOCAL_SOURCE_PATH)/$(PKG_SOURCE_PATH)
HASH := \#
# we want to extract the version that barney stashed inside an
# environment variable; we select it based first on a pattern for
# the variable name, and then filter some more on its value.
# This is not exactly a walk in the park, as a simple $(shell env |
# perl ...) unfortunately dies with the dreaded "argument list too
# long", so we resort to using .VARIABLES instead
PKG_VERSION := $(strip $(foreach V,$(.VARIABLES), \
                          $(if $(filter SRC_%, $V), \
                            $(if $(filter $(PKG_SOURCE_PATH)%, $($V)), \
                              $(subst $(PKG_SOURCE_PATH)$(HASH),,$($V))))))
# if we couldn't extract a version, go with "local"
ifeq ($(PKG_VERSION),)
PKG_VERSION := local
endif
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
	@echo "PKG_SOURCE_PATH: $(PKG_SOURCE_PATH)"
	@echo "PKG_SOURCE_PROTO: $(PKG_SOURCE_PROTO)"
	@echo "PKG_SOURCE_URL: $(PKG_SOURCE_URL)"
	@echo "USE_SOURCE_DIR: $(USE_SOURCE_DIR)"
	@echo "PKG_SOURCE_VERSION: $(PKG_SOURCE_VERSION)"
	@echo "PKG_VERSION: $(PKG_VERSION)"
