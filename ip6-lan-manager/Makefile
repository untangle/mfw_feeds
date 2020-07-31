include $(TOPDIR)/rules.mk

PKG_NAME:=ip6-lan-manager
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/ip6-lan-manager
  SECTION:=net
  CATEGORY:=Network
  TITLE:=WAN Manager
  URL:=https://github.com/untangle/mfw_feeds
  DEPENDS:=+python3 +openssh-client +openssh-server
endef

define Package/ip6-lan-manager/description
	Manages IPv6 Routes for Hosts with Public IPv6 addresses
endef

define Build/Compile
endef

define Package/ip6-lan-manager/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/ip6-lan-manager $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/ip6-lan-manager.init $(1)/etc/init.d/ip6-lan-manager
endef

$(eval $(call BuildPackage,ip6-lan-manager))
