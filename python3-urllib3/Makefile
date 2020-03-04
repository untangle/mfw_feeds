#
# Copyright (C) 2007-2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=python3-urllib3
PKG_VERSION:=1.25.3
PKG_RELEASE:=1

PKG_MAINTAINER:=Sébastien Delafond <sdelafon@gmail.com>
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE.txt

PKG_SOURCE:=urllib3-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://files.pythonhosted.org/packages/source/u/urllib3
PKG_HASH:=dbe59173209418ae49d485b87d1681aefa36252ee85884c31346debd19463232

PKG_BUILD_DIR:=$(BUILD_DIR)/$(BUILD_VARIANT)-urllib3-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include ../../packages/lang/python/python3-package.mk

PKG_UNPACK:=$(HOST_TAR) -C $(PKG_BUILD_DIR) --strip-components=1 -xzf $(DL_DIR)/$(PKG_SOURCE)

define Package/python3-urllib3
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Sanity-friendly HTTP client
  URL:=https://urllib3.readthedocs.io/
  DEPENDS:=+python3
  VARIANT:=python3
endef

define Package/python3-urllib3/description
  HTTP library with thread-safe connection pooling, file post, and more.
  .
  (Variant for Python3)
endef

$(eval $(call Py3Package,python3-urllib3))
$(eval $(call BuildPackage,python3-urllib3))
