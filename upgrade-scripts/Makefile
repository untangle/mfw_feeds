include $(TOPDIR)/rules.mk

PKG_NAME:=upgrade-scripts
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Dirk Morris <dmorris@untangle.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/upgrade-scripts
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
  TITLE:=Upgrade scripts for MFW
  URL:=https://github.com/untangle/mfw_feeds
  DEPENDS:= +gnu-wget
endef

define Package/upgrade-scripts/description
	This contains the upgrade scripts for MFW
endef

define Build/Compile
endef

define Package/upgrade-scripts/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/upgrade.sh $(1)/usr/bin/
endef

$(eval $(call BuildPackage,upgrade-scripts))
