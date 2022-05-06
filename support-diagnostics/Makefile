include $(TOPDIR)/rules.mk

PKG_NAME:=support-diagnostics
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Chris Blaise <cblaise@arista.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/support-diagnostics.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/support-diagnostics
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python3
  TITLE:=Library for manipulating MFW system settings
  URL:=https://github.com/untangle/support-diagnostics
#  PKG_BUILD_DEPENDS:=python3 python3-urllib3 python3-pyroute2
#  DEPENDS:= +diffutils +tc +kmod-sched +kmod-sched-cake +kmod-ifb +kmod-sched-connmark
endef

define Package/support-diagnostics/description
	This module is a library for analyzing a live MFW system.
endef

define Build/Compile
	$(call Build/Compile/Py3Mod,., \
		install --prefix="/usr" --root="$(PKG_INSTALL_DIR)", )
endef

define Package/support-diagnostics/install
	$(INSTALL_DIR) $(1)$(PYTHON3_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) -r \
		$(PKG_INSTALL_DIR)$(PYTHON3_PKG_DIR)/* \
		$(1)$(PYTHON3_PKG_DIR)/
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin
endef

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
