include $(TOPDIR)/rules.mk

PKG_NAME:=intrusion-prevention
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Chris Blaise <cblaise@arista.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=git@github.com:untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/intrusion-prevention
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
  TITLE:=Intrusion Prevention support scripts
  URL:=https://github.com/untangle/mfw_feeds
  DEPENDS:=+python3 +patch
endef

define Package/intrusion-prevention/description
	Intrusion Prevention support scripts
endef

define Build/Compile
endef

define Package/intrusion-prevention/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/intrusion-prevention-get-updates $(1)/usr/bin/
endef

$(eval $(call BuildPackage,intrusion-prevention))
