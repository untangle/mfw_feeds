include $(TOPDIR)/rules.mk

PKG_NAME:=packetd
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/untangle/packetd.git

include ../version.mk

GO_PKG:=github.com/untangle/packetd
GO_PKG_INSTALL_EXTRA:=packetd_rules Makefile

include $(INCLUDE_DIR)/package.mk
# FIXME: standardize on OpenWRT+golang macros, ideally we wouldn't
# have to define anything special in neither Build/Compile nor
# Package/packetd/install
include $(INCLUDE_DIR)/../feeds/mfw/golang/golang-package.mk

define Package/packetd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=Userspace packet processing daemon
  URL:=https://github.com/untangle/packetd
  PKG_BUILD_DEPENDS:=golang
  DEPENDS:=+libnetfilter-conntrack +libnetfilter-queue +libnetfilter-log +geoip-database \
	  +iptables-mod-nfqueue +kmod-nft-dict
  # FIXME: needed ?
  KCONFIG:=CONFIG_NETFILTER_NETLINK_GLUE_CT=y CONFIG_NF_CT_NETLINK_HELPER=y \
	  CONFIG_NFT_QUEUE=m CONFIG_NF_CONNTRACK_TIMESTAMP=y
endef

define Package/packetd/description
	Userspace packet processing daemon
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

define Package/packetd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(OUR_SRC_DIR)/cmd/packetd/packetd_rules $(1)/usr/bin/
	$(INSTALL_BIN) $(OUR_SRC_DIR)/cmd/packetd/packetd $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/packetd.init $(1)/etc/init.d/packetd
endef

$(eval $(call BuildPackage,packetd))
