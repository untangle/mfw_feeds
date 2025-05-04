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
  DEPENDS := +python3
endef

define Package/support-diagnostics/description
	This module is a library for analyzing a live MFW system.
endef

# Build the Python wheel
define Build/Compile
	mkdir -p $(PKG_BUILD_DIR)/openwrt-build
	cd $(PKG_BUILD_DIR); \
		python3 setup.py bdist_wheel --dist-dir openwrt-build
endef

$(info [DEBUG] Installing to $(PYTHON3_PKG_DIR))
$(info [DEBUG] Installing to $(HOST_PYTHON3))
$(info [DEBUG] Installing to $(PYTHON3_PKG_DIR))


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
define Package/support-diagnostics/install
	# Binaries (if any)
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/support-diagnostics $(1)/usr/bin
	# Library (if needed)

	$(INSTALL_DIR) $(1)$(PYTHON3_PKG_DIR)/support_diagnostics
	$(CP) -r $(PKG_INSTALL_DIR)$(PYTHON3_PKG_DIR)/support_diagnostics/* $(1)$(PYTHON3_PKG_DIR)/support_diagnostics/

endef

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))

