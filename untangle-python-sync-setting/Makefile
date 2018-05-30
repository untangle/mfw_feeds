include $(TOPDIR)/rules.mk

PKG_NAME:=untangle-python-sync-settings
PKG_VERSION:=0.1
PKG_RELEASE:=2018-05-30
PKG_LICENSE:=GPL-2.0

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_MIRROR_HASH:=b31503be646939003bb1a82671f8b7106644460a
PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/untangle/ngfw_pkgs.git/untangle-python-sync-settings
PKG_SOURCE_VERSION:=master

include $(INCLUDE_DIR)/package.mk
include ../../lang/python/python-package.mk

define Package/untangle-python-sync-settings
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Library for manipulating Untangle system settings
  MAINTAINER:=Dirk Morris <dmorris@untangle.com>
  URL:=https://untangle.com
  DEPENDS:=+python
endef

define Package/untangle-python-sync-setting/description
	This module is a Library for manipulating Untangle system settings.
endef

define Build/Compile
	$(call Build/Compile/PyMod,., \
		install --prefix="/usr" --root="$(PKG_INSTALL_DIR)", \
	)
endef

define Package/scapy/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
		$(1)$(PYTHON_PKG_DIR)/
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin
endef

$(eval $(call BuildPackage,untangle-python-sync-settings))
