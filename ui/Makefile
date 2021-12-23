include $(TOPDIR)/rules.mk

PKG_NAME:=ui
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=David Wilson <dwilson@untangle.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/mfw_ui.git

include ../version.mk

PKG_VERSION:=e2f05627d7bd7826de06517e482eb2f4d03ce0e1

include $(INCLUDE_DIR)/package.mk

define Package/ui
  SECTION:=ui
  CATEGORY:=User Interface
  TITLE:=MFW new admin interface
  URL:=https://github.com/untangle/mfw_ui
  HOST_BUILD_DEPENDS:=node-override/host node-yarn/host
  PKG_BUILD_DEPENDS:=wget node-override/host node-yarn/host
endef

define Package/ui/description
  MFW new admin interface
endef

define Build/Compile
	true
endef

define Package/ui/install
	make -C $(PKG_BUILD_DIR) DESTDIR=$(1)/www/admin install
endef

$(eval $(call BuildPackage,ui))
