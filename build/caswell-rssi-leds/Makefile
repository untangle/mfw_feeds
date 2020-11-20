include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=caswell-rssi-leds
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Brett Mastbergen <bmastbergen@untangle.com>
PKG_VERSION=1.0

include $(INCLUDE_DIR)/package.mk

define Package/caswell-rssi-leds
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:= Caswell rssi leds support
  DEPENDS:= @TARGET_x86
endef

define Package/caswell-rssi-leds/description
  Caswell rssi leds support
endef

define Build/Compile
endef

define Package/caswell-rssi-leds/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/caswell-rssi-leds.init $(1)/etc/init.d/caswell-rssi-leds
	$(INSTALL_BIN) files/disable-gnss.init $(1)/etc/init.d/disable-gnss
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/caswell-rssi-leds $(1)/usr/bin
endef

$(eval $(call BuildPackage,caswell-rssi-leds))
