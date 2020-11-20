include $(TOPDIR)/rules.mk

PKG_NAME:=container
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
# FIXME
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git
PKG_HASH:=skip

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/container
  SECTION:=admin
  CATEGORY:=Virtualization
  SUBMENU:=Container
  TITLE:=Contains kernel options for docker/lxc
  DEPENDS:=+libdevmapper +libltdl +libseccomp @!TARGET_mvebu_cortexa9_DEVICE_linksys_wrt32x
  KCONFIG:=$(shell cat Config | xargs)
endef

define Build/Compile
	true
endef

define Package/container/install
  true
endef

$(eval $(call BuildPackage,container))
