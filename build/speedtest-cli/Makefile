#
# Copyright (C) 2006-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=speedtest-cli
PKG_VERSION:=2.1.2
PKG_RELEASE:=1
PKG_LICENSE:=Apache-2.0
PKG_LICENSE_FILES:=LICENSE

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://github.com/sivel/$(PKG_NAME)/archive/v$(PKG_VERSION)
PKG_HASH:=a877142eec0ee8dda86519c36fe789480ed6fa603b016b620affd77fbf79b0d9

include $(INCLUDE_DIR)/package.mk

define Package/speedtest-cli
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Command line interface for testing internet bandwidth using speedtest.net
  MAINTAINER:=W. Michael Petullo <mike@flyn.org>
  URL:=https://github.com/sivel/speedtest-cli
  DEPENDS:=+python3
endef

define Package/speedtest-cli/description
  Command line interface for testing internet bandwidth using speedtest.net
endef

define Build/Compile
endef

define Package/speedtest-cli/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/speedtest.py $(1)/usr/bin/speedtest-cli
endef

$(eval $(call BuildPackage,speedtest-cli))
