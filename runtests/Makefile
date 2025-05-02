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

define Py3Package/runtests/installdefine Build/Prepare
  $(Build/Prepare/Default)
  $(CP) -r "$(PKG_SOURCE_DIR)/files" "$(PKG_BUILD_DIR)/"
endef

define Build/Compile
  #  Explicitly build the wheel.
  $(HOSTPYTHON) setup.py sdist bdist_wheel
endef

define Package/$(PKG_NAME)/install
  # Install the Python package from the wheel (handled by Py3Package)
  $(call Py3Package/$(PKG_NAME)/install,$(1))

  # Install extra data files (including tests)
  $(INSTALL_DIR) $(1)$(PYTHON3_PKG_DIR)/runtests/tests  # Install to package's tests dir
  $(CP) -r "$(PKG_BUILD_DIR)/files/*" "$(1)$(PYTHON3_PKG_DIR)/runtests/tests/"
endef

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
	# bin
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/runtests $(1)/usr/bin

	$(INSTALL_DIR) $(1)/usr/lib/runtests
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/runtests $(1)/usr/lib

	# Tests
	$(INSTALL_DIR) $(1)$(PYTHON3_PKG_DIR)/tests
	$(CP) files/usr/lib/python/tests/* $(1)$(PYTHON3_PKG_DIR)/tests
endef

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
