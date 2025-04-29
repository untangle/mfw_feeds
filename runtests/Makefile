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

define Py3Package/runtests/Build/Prepare
	$(call Build/Prepare/Default)
	$(CP) -r $(CURDIR)/files/usr/lib/python/tests \
	       $(PKG_BUILD_DIR)/runtests/tests
endef

# 2) Compile: build one wheel under openwrt-build/
define Py3Package/runtests/Build/Compile
	cd $(PKG_BUILD_DIR) && \
	$(HOST_PYTHON3) -m build --wheel --outdir openwrt-build
endef

# 3) InstallDev: pick that wheel (no wildcard!) and install it
define Py3Package/runtests/Build/InstallDev
	WHEEL=$(firstword $(wildcard $(PKG_BUILD_DIR)/openwrt-build/*.whl)); \
	[ -n "$$WHEEL" ] || (echo "no .whl found" >&2; exit 1); \
	$(HOST_PYTHON3) -m installer \
	  --destdir="$(PKG_INSTALL_DIR)" \
	  --no-compile-bytecode \
	  --prefix=/usr \
	  "$$WHEEL"
endef

# 4) Package/install: let Py3Package do its thing (tests are now in the wheel)
define Package/runtests/install
	$(call Py3Package/runtests/install,$(1))
endef

$(eval $(call Py3Package,runtests))
$(eval $(call BuildPackage,runtests))
