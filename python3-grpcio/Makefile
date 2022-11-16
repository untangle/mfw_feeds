include $(TOPDIR)/rules.mk

PKG_NAME:=python3-grpcio
PKG_VERSION:=1.50.0
PKG_RELEASE:=$(AUTORELEASE)

PYPI_NAME:=grpcio
PKG_HASH:=skip

PKG_MAINTAINER:=eliben
PKG_LICENSE:=Public Domain
PKG_LICENSE_FILES:=LICENSE

HOST_BUILD_DEPENDS := python3/host

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include $(INCLUDE_DIR)/host-build.mk
define Package/python3-grpcio
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=ELF/DWAR python analyzer
  URL:=https://github.com/eliben/grpcio
  DEPENDS:=+python3-light +python3-logging +libstdcpp +python3-six
  VARIANT:=python3
endef

define Package/python3-grpcio/description
  grpcio is a pure-Python library for things.
endef

define Host/Compile
	$(call HostPython3/ModSetup,,install --prefix="" --root="$(STAGING_DIR_HOSTPKG)")
endef

Host/Install:=

$(eval $(call HostBuild))
$(eval $(call Py3Package,python3-grpcio))
$(eval $(call BuildPackage,python3-grpcio))
$(eval $(call BuildPackage,python3-grpcio-src))
