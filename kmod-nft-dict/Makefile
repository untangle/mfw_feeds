include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=nft-dict
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Brett Mastbergen <bmastbergen@untangle.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/untangle/nft_dict.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define KernelPackage/nft-dict
  SUBMENU:=Network Support
  TITLE:=Netfilter generic dictionary support
  URL:=https://github.com/untangle/nft_dict
  FILES:=$(PKG_BUILD_DIR)/dict.ko \
         $(PKG_BUILD_DIR)/nft_dict.ko
  AUTOLOAD:=$(call AutoLoad,75,dict)
  DEPENDS:=+kmod-nft-core
endef

include $(INCLUDE_DIR)/kernel-defaults.mk

define KernelPackage/nft-dict/description
  Netfilter generic dictionary support
endef

define Build/Compile
	$(KERNEL_MAKE) M="$(PKG_BUILD_DIR)" modules
endef

$(eval $(call KernelPackage,nft-dict))
