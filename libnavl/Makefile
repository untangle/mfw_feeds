#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=libnavl
PKG_RELEASE:=2018-05-09

include $(INCLUDE_DIR)/package.mk

define Package/libnavl
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libstdcpp
  TITLE:=Traffic Classification Library
  VERSION:=$(PKG_RELEASE)
  MAINTAINER:=Michael Hotz <mahotz@untangle.com>
  URL:=https://www.github.com/untangle/ngfw_hades-pkgs/untangle-classd
endef

define Package/libnavl/description
  Userspace packet processing daemon
endef

define Build/Prepare
	$(CP) src/libnavl.so.4.5 $(PKG_BUILD_DIR)/
endef

define Build/Compile
	true
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libnavl.so.4.5 $(1)/usr/lib/
endef

define Package/libnavl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/libnavl.so.4.5 $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libnavl))
