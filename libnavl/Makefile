include $(TOPDIR)/rules.mk

PKG_NAME:=libnavl
PKG_RELEASE:=2018-05-09

PKG_SOURCE:=libnavl.so.4.5.0
PKG_SOURCE_URL:=http://foo:foo@updates.untangle.com/public/openwrt
PKG_HASH:=edd381c64149086a3da2adf09c48e7162f345143a7cf8afe2ca75d949bf7f40d

include $(INCLUDE_DIR)/package.mk

define Package/libnavl
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libstdcpp
  TITLE:=Traffic Classification Library
  VERSION:=$(PKG_RELEASE)
  MAINTAINER:=Michael Hotz <mahotz@untangle.com>
endef

define Package/libnavl/description
  Userspace packet processing daemon
endef

define Build/Compile
	true
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(BUILD_DIR)/$(PKG_SOURCE) $(1)/usr/lib/
endef

define Package/libnavl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) /usr/lib/$(PKG_SOURCE) $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libnavl))
