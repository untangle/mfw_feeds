include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=caswell-wifi-led
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Brett Mastbergen <bmastbergen@untangle.com>
PKG_VERSION=1.0

include $(INCLUDE_DIR)/package.mk

define Package/caswell-wifi-led
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:= Caswell wifi led support
  DEPENDS:= @TARGET_x86 +kmod-gpio-nuvoton +kmod-ledtrig-netdev
endef

define Package/caswell-wifi-led/description
  Caswell wifi led support
endef

define Build/Compile
endef

define Package/caswell-wifi-led/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/caswell-wifi-led.init $(1)/etc/init.d/caswell-wifi-led
endef

$(eval $(call BuildPackage,caswell-wifi-led))
