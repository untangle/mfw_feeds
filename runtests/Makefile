include $(TOPDIR)/rules.mk

PKG_NAME:=runtests
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Chris Blaise <cblaise@arista.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/runtests.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/runtests
  SUBMENU:=Python
  SECTION:=lang
  CATEGORY:=Languages
  TITLE:=Library for running MFW tests
  URL:=https://github.com/untangle/runtests
  DEPENDS:= +python3 +python3-requests +python3-unittest
endef

define Package/runtests/description
	This module is a Library for running functional MFW tests.
endef

define Build/Prepare
  $(Build/Prepare/Default)
  $(CP) -r "$(PKG_SOURCE_DIR)/files" "$(PKG_BUILD_DIR)/"
endef

define Build/Compile
  #  Explicitly build the wheel.  This is crucial.
  $(HOSTPYTHON) setup.py sdist bdist_wheel
endef

define Package/$(PKG_NAME)/install
  # Install everything from the staging directory
  $(INSTALL_DIR_RUNTIME) $(1)
  $(CP) -r "$(PKG_BUILD_DIR)/usr" "$(1)/"
endef

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
