#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=geoip-database
PKG_RELEASE:=2018-05-09

PKG_SOURCE:=GeoLite2-Country.mmdb.gz
PKG_SOURCE_URL:=http://geolite.maxmind.com/download/geoip/database
PKG_HASH:=238555277c1a7cc71f10fcba6f42e84692d441960a6d828d0236c05df35f73df

include $(INCLUDE_DIR)/package.mk

define Package/geoip-database
  SECTION:=libs
  CATEGORY:=Libraries
  TITLE:=IP Geolocation Database
  VERSION:=$(PKG_RELEASE)
  MAINTAINER:=Michael Hotz <mahotz@untangle.com>
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
	$(INSTALL_DIR) $(1)/usr/lib $(1)/etc/init.d
	$(INSTALL_BIN) files/geoip-database.init $(1)/etc/init.d
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/GeoLite2-Country.mmdb $(1)/usr/lib/
endef

$(eval $(call BuildPackage,geoip-database))
