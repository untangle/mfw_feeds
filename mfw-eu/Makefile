include $(TOPDIR)/rules.mk

PKG_NAME:=mfw-eu
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/mfw-eu
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
  TITLE:=EU package
  URL:=https://github.com/untangle/mfw_feeds
  DEPENDS:=
endef

define Package/mfw-eu/description
	This contains the files for the EU version of MFW
endef

define Build/Compile
endef

define Package/mfw-eu/install
	$(INSTALL_DIR) $(1)/etc
	$(INSTALL_BIN) files/foo $(1)/etc/
endef

$(eval $(call BuildPackage,mfw-eu))
