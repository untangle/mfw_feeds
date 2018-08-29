include $(TOPDIR)/rules.mk

PKG_NAME:=sync-settings
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/untangle/ngfw_pkgs.git

include ../version.mk
PKG_VERSION:=$(call UNTANGLE_VERSION,$(PKG_SOURCE_URL))
PKG_SOURCE_VERSION:=$(PKG_VERSION)

PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include ../../packages/lang/python/python3-package.mk

define Package/sync-settings
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python3
  TITLE:=Library for manipulating Untangle system settings
  URL:=https://untangle.com
  DEPENDS:=+python3 +diffutils
endef

define Package/sync-settings/description
	This module is a Library for manipulating Untangle system settings.
endef

define Build/Compile
	$(call Build/Compile/Py3Mod,$(PKG_NAME), \
		install --prefix="/usr" --root="$(PKG_INSTALL_DIR)", )
endef

define Package/sync-settings/install
	$(INSTALL_DIR) $(1)$(PYTHON3_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON3_PKG_DIR)/* \
		$(1)$(PYTHON3_PKG_DIR)/
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/sync-settings.init $(1)/etc/init.d/sync-settings
	$(INSTALL_BIN) files/nftables-rules.init $(1)/etc/init.d/nftables-rules
endef

$(eval $(call Py3Package,sync-settings))
$(eval $(call BuildPackage,sync-settings))
