include $(TOPDIR)/rules.mk

PKG_NAME:=client-license-service
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/client-license-service.git

include ../version.mk

GO_PKG:=github.com/untangle/client-license-service
GO_PKG_INSTALL_EXTRA:=Makefile

PKG_BUILD_DEPENDS:=golang/host

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/client-license-service
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=Userspace license client
  URL:=https://github.com/untangle/client-license-service
endef

define Package/client-license-service/description
	Userspace license client
endef

OUR_SRC_DIR:=$(GO_PKG_BUILD_DIR)/src/$(GO_PKG)

define Build/Compile
	cd $(OUR_SRC_DIR); \
	export GOPATH=$(GO_PKG_BUILD_DIR) \
                        GOCACHE=$(GO_PKG_CACHE_DIR) \
                        GOTMPDIR=$(GO_PKG_TMP_DIR) \
                        GOROOT_FINAL=$(GO_TARGET_ROOT) \
                        CC=$(TARGET_CC) \
                        CXX=$(TARGET_CXX) \
                        $(call GoPackage/Environment) ; \
	make GOFLAGS=$(MFW_GOFLAGS) build
endef

define Package/client-license-service/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(OUR_SRC_DIR)/build/client-license-service $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/clientlic.init $(1)/etc/init.d/clientlic
endef

$(eval $(call BuildPackage,client-license-service))
