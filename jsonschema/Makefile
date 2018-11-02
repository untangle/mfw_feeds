#
# Copyright (C) 2007-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=jsonschema
PKG_VERSION:=2.6.0
PKG_RELEASE:=1
PKG_LICENSE:=MIT

PKG_SOURCE:=jsonschema-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://files.pythonhosted.org/packages/source/j/jsonschema
PKG_HASH:=6ff5f3180870836cae40f06fa10419f557208175f13ad7bc26caa77beb1f6e02

include $(INCLUDE_DIR)/package.mk
include ../../packages/lang/python/python3-package.mk

define Package/jsonschema
  SUBMENU:=Python3
  SECTION:=lang
  CATEGORY:=Languages
  MAINTAINER:=Julian Berman <julian@grayvines.com>
  TITLE:=An implementation of JSON Schema validation for Python
  URL:=https://python-jsonschema.readthedocs.io/en/v2.6.0
  DEPENDS:=+python3
endef

define Package/jsonschema/description
  An implementation of JSON Schema validation for Python
endef

define Build/Compile
	$(call Build/Compile/Py3Mod,,install --prefix=/usr --root=$(PKG_INSTALL_DIR))
endef

define Package/jsonschema/install
	$(INSTALL_DIR) $(1)$(PYTHON_PKG_DIR)
	$(CP) \
	    $(PKG_INSTALL_DIR)$(PYTHON_PKG_DIR)/* \
	    $(1)$(PYTHON_PKG_DIR)
endef

$(eval $(call BuildPackage,jsonschema))
