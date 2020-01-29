include $(TOPDIR)/rules.mk

PKG_NAME:=geoip-database
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_VERSION:=latest
PKG_SOURCE:=GeoLite2-Country.tar.gz
PKG_SOURCE_URL:=https://downloads.untangle.com/download.php?resource=geoipCountry
PKG_HASH:=skip

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
	tar -C $(PKG_BUILD_DIR) --strip=1 -xavf $(DL_DIR)/$(PKG_SOURCE)
endef

define Build/Compile
	true
endef

define Package/geoip-database/install
	$(INSTALL_DIR) $(1)/usr/share/geoip
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/GeoLite2-Country.mmdb $(1)/usr/share/geoip
endef

$(eval $(call BuildPackage,geoip-database))
