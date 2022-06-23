include $(TOPDIR)/rules.mk

PKG_NAME:=mfw-eu
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Chris Blaise <cblaise@untangle.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/mfw-eu
  SECTION:=net
  CATEGORY:=Network
  TITLE:=MFW EU
  URL:=https://github.com/untangle/mfw_feeds
endef

define Package/mfw-eu/description
	Manages MFW European region
endef

define Build/Compile
endef

define Package/mfw-eu/install
	$(INSTALL_DIR) $(1)/usr/share/settings-templates
	$(INSTALL_BIN) files/settings_uri.js $(1)/usr/share/settings-templates
endef

$(eval $(call BuildPackage,mfw-eu))
