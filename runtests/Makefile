include $(TOPDIR)/rules.mk

PKG_NAME:=runtests
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Chris Blaise <cblaise@arista.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/runtests.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

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

# Build the Python wheel
define Build/Compile
	mkdir -p $(PKG_BUILD_DIR)/openwrt-build
	cd $(PKG_BUILD_DIR)/runtests; \
		$(HOST_PYTHON3) setup.py bdist_wheel --dist-dir openwrt-build
endef

# Install the wheel using python3 -m installer
define Py3Build/Install/Default
	$(call Python3/Run, \
		$(PKG_BUILD_DIR), \
		-m installer \
			--destdir "$(PKG_INSTALL_DIR)" \
			--no-compile-bytecode \
			--prefix /usr \
			"$(PKG_BUILD_DIR)/openwrt-build/"*.whl \
		, \
		$(PYTHON3_PKG_INSTALL_VARS) \
	)
endef

# Install additional files like test scripts
define Package/runtests/install
	# Binaries (if any)
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/runtests $(1)/usr/bin

	# Library (if needed)
	$(INSTALL_DIR) $(1)/usr/lib/runtests
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/runtests $(1)/usr/lib

	# Tests from feeds/mfw/runtests/files/
	$(INSTALL_DIR) $(1)$(PYTHON3_PKG_DIR)/tests
	$(CP) files/usr/lib/python/tests/* $(1)$(PYTHON3_PKG_DIR)/tests
endef

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
