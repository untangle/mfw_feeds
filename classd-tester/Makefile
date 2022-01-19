include $(TOPDIR)/rules.mk

PKG_NAME:=classd-tester
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:jsommerville-untangle/classd-tester.git

include ../version.mk

GO_PKG:=github.com/jsommerville-untangle/classd-tester
GO_PKG_INSTALL_EXTRA:=Makefile

include $(INCLUDE_DIR)/package.mk
# FIXME: standardize on OpenWRT+golang macros, ideally we wouldn't
# have to define anything special in neither Build/Compile nor
# Package/packetd/install
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/classd-tester
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=Userspace packet processing daemon
  URL:=https://github.com/jsommerville-untangle/classd-tester
  PKG_BUILD_DEPENDS:=golang
endef

define Package/classd-tester/description
	Classd testing device
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
	make
endef

define Package/classd-tester/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(OUR_SRC_DIR)/cmd/classd-tester/classd-tester $(1)/usr/bin/
endef

$(eval $(call BuildPackage,packetd))
