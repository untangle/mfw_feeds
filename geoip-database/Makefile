include $(TOPDIR)/rules.mk

PKG_NAME:=geoip-database
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_VERSION:=latest
PKG_SOURCE:=GeoLite2-Country.mmdb.gz
PKG_SOURCE_URL:=http://geolite.maxmind.com/download/geoip/database
PKG_HASH:=4502f8783937eee9ceb2c58115c358b7e81ee8bb3d024576ff67472ac0a554c5

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
	$(INSTALL_BIN) files/geoip-database.init $(1)/etc/init.d/geoip-database
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/GeoLite2-Country.mmdb $(1)/usr/share/untangle-geoip
endef

$(eval $(call BuildPackage,geoip-database))
