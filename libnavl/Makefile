include $(TOPDIR)/rules.mk

PKG_NAME:=libnavl
PKG_VERSION:=4.5.0
PKG_RELEASE:=2018-05-09

PKG_SOURCE:=$(PKG_NAME)/$(PKG_VERSION).tar.xz
PKG_SOURCE_URL:=http://foo:foo@updates.untangle.com/public/openwrt
PKG_HASH:=56282ada54152a1b89bba7fa966ddf743587ceacda219689762f91a7ff32154e

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
	$(INSTALL_BIN) $(BUILD_DIR)/$(PKG_NAME).so.$(PKG_VERSION) $(1)/usr/lib/
endef

define Package/libnavl/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) /usr/lib/$(PKG_NAME).so.$(PKG_VERSION) $(1)/usr/lib/
endef

$(eval $(call BuildPackage,libnavl))
