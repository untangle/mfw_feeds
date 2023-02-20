include $(TOPDIR)/rules.mk

PKG_NAME:=alertd
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/alertd.git

include ../version.mk

GO_PKG:=github.com/untangle/alertd
GO_PKG_INSTALL_EXTRA:=Makefile

PKG_BUILD_DEPENDS:=golang/host

include $(INCLUDE_DIR)/package.mk
# FIXME: standardize on OpenWRT+golang macros, ideally we wouldn't
# have to define anything special in neither Build/Compile nor
# Package/packetd/install
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/alertd
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Alert daemon for processing alerts
  URL:=https://github.com/untangle/alertd
  DEPENDS:=+libsodium +libzmq-curve
endef

define Package/alertd/description
	Alerts processing daemon
endef

OUR_SRC_DIR:=$(GO_PKG_BUILD_DIR)/src/$(GO_PKG)

define Build/Compile
	cd $(OUR_SRC_DIR) ; \
	export GOPATH=$(GO_PKG_BUILD_DIR) \
                        GOCACHE=$(GO_PKG_CACHE_DIR) \
                        GOTMPDIR=$(GO_PKG_TMP_DIR) \
                        GOROOT_FINAL=$(GO_TARGET_ROOT) \
                        CC=$(TARGET_CC) \
                        CXX=$(TARGET_CXX) \
                        $(call GoPackage/Environment) ; \
	make GOFLAGS=$(MFW_GOFLAGS) build
endef

define Package/alertd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(OUR_SRC_DIR)/cmd/alertd/alertd $(1)/usr/bin/alertd
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/alertd.init $(1)/etc/init.d/alertd
endef

$(eval $(call BuildPackage,alertd))
