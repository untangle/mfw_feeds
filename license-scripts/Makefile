include $(TOPDIR)/rules.mk

PKG_NAME:=license-scripts
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Dirk Morris <dmorris@untangle.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/license-scripts
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
  TITLE:=License scripts for MFW
  URL:=https://github.com/untangle/mfw_feeds
  DEPENDS:=
endef

define Package/license-scripts/description
	This contains the license scripts for MFW
endef

define Build/Compile
endef

define Package/license-scripts/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/fetch-licenses.sh $(1)/usr/bin/
	$(INSTALL_BIN) files/interface-kbps $(1)/usr/bin/

	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/fetch-licenses.init $(1)/etc/init.d/fetch-licenses
endef

$(eval $(call BuildPackage,license-scripts))
