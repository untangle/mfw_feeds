include $(TOPDIR)/rules.mk

PKG_NAME:=geoip-database
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_VERSION:=latest
PKG_SOURCE:=GeoLite2-Country.mmdb.gz
PKG_SOURCE_URL:=http://geolite.maxmind.com/download/geoip/database
PKG_HASH:=51ae8543dcd97fd037de6489410d163600bd5038630d037a43f3a296d2bc0794

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
	$(INSTALL_DIR) $(1)/usr/share/geoip
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/GeoLite2-Country.mmdb $(1)/usr/share/geoip
endef

$(eval $(call BuildPackage,geoip-database))
