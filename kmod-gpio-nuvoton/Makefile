include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=gpio-nuvoton
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Brett Mastbergen <bmastbergen@untangle.com>

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/kernel-defaults.mk

define KernelPackage/gpio-nuvoton
  SUBMENU:=Other modules
  TITLE:= GPIO nuvoton support
  DEPENDS:= @TARGET_x86
  FILES:=$(PKG_BUILD_DIR)/gpio-nuvoton.ko
  AUTOLOAD:=$(call AutoLoad,30,gpio-nuvoton)
  KCONFIG:=
endef

define KernelPackage/gpio-nuvoton/description
  Nuvoton gpio support
endef

define Build/Compile
	$(KERNEL_MAKE) SUBDIRS="$(PKG_BUILD_DIR)" modules
endef

$(eval $(call KernelPackage,gpio-nuvoton))
