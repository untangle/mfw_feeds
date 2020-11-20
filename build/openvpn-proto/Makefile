include $(TOPDIR)/rules.mk

PKG_NAME:=openvpn-proto
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Brett Mastbergen <bmastbergen@untangle.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/openvpn-proto
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=VPN
  TITLE:=openvpn protocol support for netifd
  DEPENDS:=+openvpn-openssl
endef

define Package/openvpn-proto/description
	Adds openvpn protocol support for netifd
endef

define Build/Compile
endef

define Package/openvpn-proto/install
	$(INSTALL_DIR) $(1)/lib/netifd
	$(INSTALL_DIR) $(1)/lib/netifd/proto
	$(INSTALL_BIN) files/openvpn.sh $(1)/lib/netifd/proto
	$(INSTALL_BIN) files/openvpn-up $(1)/lib/netifd
	$(INSTALL_BIN) files/openvpn-down $(1)/lib/netifd
endef

$(eval $(call BuildPackage,openvpn-proto))
