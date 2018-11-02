include $(TOPDIR)/rules.mk

PKG_NAME:=python3-vcversioner
PKG_VERSION:=2.16.0.0
PKG_RELEASE:=1
PKG_LICENSE:=ISC

PKG_SOURCE:=vcversioner-$(PKG_VERSION).tar.gz
PKG_SOURCE_URL:=https://pypi.python.org/packages/c5/cc/33162c0a7b28a4d8c83da07bc2b12cee58c120b4a9e8bba31c41c8d35a16
PKG_HASH:=dae60c17a479781f44a4010701833f1829140b1eeccd258762a74974aa06e19b
PKG_BUILD_DIR:=$(BUILD_DIR)/vcversioner-$(PKG_VERSION)

include $(INCLUDE_DIR)/package.mk
include ../../packages/lang/python/python3-package.mk

define Package/python3-vcversioner
  SUBMENU:=Python3
  SECTION:=lang
  CATEGORY:=Languages
  MAINTAINER:=Aaron Gallagher
  TITLE:=Use version control tags to discover version numbers
  URL:=https://pypi.org/project/vcversioner/
  DEPENDS:=+python3
endef

define Package/python3-vcversioner/description
  Write a setup.py with no version information specified, and vcversioner will find a recent, properly-formatted VCS tag and extract a version from it.
endef

define Build/Compile
	$(call Build/Compile/Py3Mod,., \
		install --prefix=/usr --root=$(PKG_INSTALL_DIR), )
endef

define Package/python3-vcversioner/install
	$(INSTALL_DIR) $(1)$(PYTHON3_PKG_DIR)
	$(CP) \
	    $(PKG_INSTALL_DIR)$(PYTHON3_PKG_DIR)/* \
	    $(1)$(PYTHON3_PKG_DIR)
endef

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
