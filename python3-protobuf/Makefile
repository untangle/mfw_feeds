include $(TOPDIR)/rules.mk

PKG_NAME:=python3-protobuf
PKG_VERSION:=4.21.9
PKG_RELEASE:=$(AUTORELEASE)

PYPI_NAME:=protobuf
PKG_HASH:=skip

PKG_MAINTAINER:=eliben
PKG_LICENSE:=Public Domain
PKG_LICENSE_FILES:=LICENSE

HOST_BUILD_DEPENDS := python3/host

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include $(INCLUDE_DIR)/host-build.mk
define Package/python3-protobuf
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=ELF/DWAR python analyzer
  URL:=https://github.com/eliben/protobuf
  DEPENDS:=+python3-light +python3-logging
  VARIANT:=python3
endef

define Package/python3-protobuf/description
  protobuf is a pure-Python library for the things.
endef

define Host/Compile
	$(call HostPython3/ModSetup,,install --prefix="" --root="$(STAGING_DIR_HOSTPKG)")
endef

Host/Install:=

$(eval $(call HostBuild))
$(eval $(call Py3Package,python3-protobuf))
$(eval $(call BuildPackage,python3-protobuf))
$(eval $(call BuildPackage,python3-protobuf-src))
