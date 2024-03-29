include $(TOPDIR)/rules.mk

PKG_NAME:=reportd
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/reportd.git

include ../version.mk

GO_PKG:=github.com/untangle/reportd
GO_PKG_INSTALL_EXTRA:=Makefile

PKG_BUILD_DEPENDS:=golang/host

include $(INCLUDE_DIR)/package.mk
# FIXME: standardize on OpenWRT+golang macros, ideally we wouldn't
# have to define anything special in neither Build/Compile nor
# Package/packetd/install
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/reportd
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Report daemon for logging and database interaction
  URL:=https://github.com/untangle/reportd
  DEPENDS:=+libsodium +libzmq-curve +credentials
endef

define Package/reportd/description
	Reports processing and event engine
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

define Package/reportd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(OUR_SRC_DIR)/cmd/reportd/reportd $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/reportd.init $(1)/etc/init.d/reportd
endef

$(eval $(call BuildPackage,reportd))
