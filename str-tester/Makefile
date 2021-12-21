include $(TOPDIR)/rules.mk

PKG_NAME:=str-tester
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Dirk Morris <dmorris@untangle.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

PKG_NAME_NO_DASH = $(subst -,_,$(PKG_NAME))
PKG_SOURCE_VERSION:=str-tester 

PKG_VERSION:=1.0

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_SOURCE_VERSION)-$(PKG_VERSION).tar.xz

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

define Build/Compile
	cd $(PKG_BUILD_DIR)/files ; \
	export GOPATH=$(GO_PKG_BUILD_DIR) \
                        GOCACHE=$(GO_PKG_CACHE_DIR) \
                        GOTMPDIR=$(GO_PKG_TMP_DIR) \
                        GOROOT_FINAL=$(GO_TARGET_ROOT) \
                        CC=$(TARGET_CC) \
                        CXX=$(TARGET_CXX) \
                        $(call GoPackage/Environment) ; \
	go build str_tester.go -o str-tester
endef

define Package/str-tester/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/str-tester $(1)/usr/bin/
endef

$(eval $(call BuildPackage,str-tester))
