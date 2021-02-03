include $(TOPDIR)/rules.mk

PKG_NAME:=bctid
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/bctid.git
PKG_SOURCE_VERSION:=mfw-1320

include ../version.mk

include $(INCLUDE_DIR)/package.mk
# include $(INCLUDE_DIR)/cmake.mk

define Package/bctid
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=BrightCloud Threat Intelligence Daemon
  URL:=https://github.com/untangle/bctid
  DEPENDS:=+libidn2
endef

define Package/bctid/description
  BrightCloud Threat Intelligence Daemon
endef

define Build/Compile
	docker-compose -f docker-compose.build.yml run build
endef

define Package/bctid/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/usr/lib $(1)/usr/share/untangle-btcid
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/bin/bctid $(1)/usr/bin/
	$(CP) $(PKG_INSTALL_DIR)/bin/bctid.cfg $(1)/usr/share/untangle-bctid/
	$(CP) $(PKG_INSTALL_DIR)/database/public_suffix_list.dat $(1)/usr/share/untangle-bctid/
endef

$(eval $(call BuildPackage,bctid))
