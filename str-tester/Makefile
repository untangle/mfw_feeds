include $(TOPDIR)/rules.mk

PKG_NAME:=str-tester
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Dirk Morris <dmorris@untangle.com>
PKG_VERSION:=1.0

include $(INCLUDE_DIR)/package.mk

include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/str-tester
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
  TITLE:=Testing string optimization
  URL:=https://github.com/untangle/mfw_feeds
  DEPENDS:=
  PKG_BUILD_DEPENDS:=golang
endef

define Package/str-tester/description
	This contains the upgrade scripts for MFW
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
endef

define Build/Compile
	export GOPATH=$(GO_PKG_BUILD_DIR) \
                        GOCACHE=$(GO_PKG_CACHE_DIR) \
                        GOTMPDIR=$(GO_PKG_TMP_DIR) \
                        GOROOT_FINAL=$(GO_TARGET_ROOT) \
                        CC=$(TARGET_CC) \
                        CXX=$(TARGET_CXX) \
                        $(call GoPackage/Environment) ; \
	go build str_tester.go -o $(PKG_BUILD_DIR)/str-tester
endef

define Package/str-tester/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/str-tester $(1)/usr/bin/
endef

$(eval $(call BuildPackage,str-tester))
