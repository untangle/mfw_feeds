include $(TOPDIR)/rules.mk

PKG_NAME:=geoip-database
PKG_VERSION:=latest

PKG_SOURCE:=GeoLite2-Country.mmdb.gz
PKG_SOURCE_URL:=http://geolite.maxmind.com/download/geoip/database
PKG_HASH:=dea358329840929e93c00c4e4cf1a27e694fe9bb19ea150193849a7533d98939

PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/geoip-database
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=IP Geolocation Database
endef

define Package/geoip-database/description
  IP Geolocation Database
endef

define Build/Prepare
	rm -rf $(PKG_BUILD_DIR)
	mkdir -p $(PKG_BUILD_DIR)
	gunzip -c $(DL_DIR)/$(PKG_SOURCE) > $(PKG_BUILD_DIR)/GeoLite2-Country.mmdb
endef

define Build/Compile
	true
endef

define Package/geoip-database/install
	$(INSTALL_DIR) $(1)/usr/share/untangle-geoip $(1)/etc/init.d
	$(INSTALL_BIN) files/geoip-database.init $(1)/etc/init.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/GeoLite2-Country.mmdb $(1)/usr/share/untangle-geoip
endef

$(eval $(call BuildPackage,geoip-database))
