include $(TOPDIR)/rules.mk

PKG_NAME:=discoverd
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/discoverd.git

include ../version.mk

GO_PKG:=github.com/untangle/discoverd
GO_PKG_INSTALL_EXTRA:=Makefile

PKG_BUILD_DEPENDS:=golang/host

include $(INCLUDE_DIR)/package.mk
# FIXME: standardize on OpenWRT+golang macros, ideally we wouldn't
# have to define anything special in neither Build/Compile nor
# Package/packetd/install
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/discoverd
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Host discovery daemon
  URL:=https://github.com/untangle/discoverd
  DEPENDS:=+libsodium +libzmq-curve +nmap-ssl +lldpd +lsof
endef

define Package/discoverd/description
  Host discovery daemon
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

define Package/discoverd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(OUR_SRC_DIR)/cmd/discoverd/discoverd $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/discoverd.init $(1)/etc/init.d/discoverd
  $(INSTALL_BIN) files/discoverd_monitor.init $(1)/etc/init.d/discoverd_monitor
	$(INSTALL_BIN) files/discoverd_monitor.sh $(1)/usr/bin/
endef

$(eval $(call BuildPackage,discoverd))
