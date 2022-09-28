include $(TOPDIR)/rules.mk

PKG_NAME:=b5
PKG_VERSION=beta
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:barney-ci/apiserver.git
PKG_SOURCE_VERSION=7be10e4758c0276fdaa309b330f94c6534581047
PKG_SOURCE := $(PKG_NAME)-$(PKG_SOURCE_VERSION).tar.xz


PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_MAINTAINER:=Arista Networks

PKG_BUILD_DEPENDS:=golang/host
HOST_BUILD_DEPENDS:=golang/host

GO_PKG:=github.com/barney-ci/apiserver
GO_PKG_BUILD_PKG:=github.com/barney-ci/apiserver/cmd/b5

include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-host-build.mk
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/b5
	SECTION:=utils
	CATEGORY:=Utilities
	TITLE:=B5 Package tooling to enable B5 packages
	URL:=https://barney-ci/apiserver.git
	DEPENDS:=$(GO_ARCH_DEPENDS)
endef

define Package/b5/description
	B5 Package tooling to enable pulling in B5 packages
endef

OUR_SRC_DIR:=$(GO_PKG_BUILD_DIR)/src/$(GO_PKG)

define Build/Compile
	cd $(OUR_SRC_DIR) ; \
	go build -o ./b5 ./cmd/b5
endef


$(eval $(call GoBinHostBuild))
$(eval $(call HostBuild))
$(eval $(call GoBinPackage,b5))
$(eval $(call BuildPackage,b5))
