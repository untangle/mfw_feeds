include $(TOPDIR)/rules.mk

PKG_NAME:=python3-pyelftools
PKG_VERSION:=0.28
PKG_RELEASE:=$(AUTORELEASE)

PYPI_NAME:=pyelftools
PKG_HASH:=53e5609cac016471d40bd88dc410cd90755942c25e58a61021cfdf7abdfeacff

PKG_MAINTAINER:=eliben
PKG_LICENSE:=Public Domain
PKG_LICENSE_FILES:=LICENSE

HOST_BUILD_DEPENDS := python3/host

include $(TOPDIR)/feeds/packages/lang/python/pypi.mk
include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include $(INCLUDE_DIR)/host-build.mk
define Package/python3-pyelftools
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python
  TITLE:=ELF/DWAR python analyzer
  URL:=https://github.com/eliben/pyelftools
  DEPENDS:=+python3-light +python3-logging
  VARIANT:=python3
endef

define Package/python3-pyelftools/description
  pyelftools is a pure-Python library for parsing and analyzing ELF files and DWARF debugging information. See the Users guide for more details.
endef

define Host/Compile
	$(call HostPython3/ModSetup,,install --prefix="" --root="$(STAGING_DIR_HOSTPKG)")
endef

Host/Install:=

$(eval $(call HostBuild))
$(eval $(call Py3Package,python3-pyelftools))
$(eval $(call BuildPackage,python3-pyelftools))
$(eval $(call BuildPackage,python3-pyelftools-src))
