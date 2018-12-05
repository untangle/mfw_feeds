include $(TOPDIR)/rules.mk

PKG_NAME:=classd
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/untangle/classd.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/classd
  SECTION:=ui
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=Userspace classification daemon
  URL:=https://www.github.com/untangle/classd
endef

define Package/classd/description
  Userspace classification daemon
endef

define Build/Compile
	make -C $(PKG_BUILD_DIR) MUSL=1
endef

define Package/classd/install
	make -C $(PKG_BUILD_DIR) MUSL=1 DESTDIR=$(1) install
endef

$(eval $(call BuildPackage,classd))
