include $(TOPDIR)/rules.mk

PKG_NAME:=admin
PKG_VERSION:=latest
PKG_LICENSE:=GPL-2.0

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/untangle/mfw-admin.git
# FIXME: this should be a tag, as should PKG_VERSION above
PKG_SOURCE_VERSION:=makefile
# PKG_SOURCE_VERSION:=$(shell git ls-remote $(PKG_SOURCE_URL) $(PKG_BRANCH) ...)
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz

PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>

include $(INCLUDE_DIR)/package.mk

define Package/admin
  SECTION:=ui
  CATEGORY:=User Interface
  TITLE:=MFW admin interface
endef

define Package/admin/description
  MFW admin interface
endef

define Build/Compile
	true
endef

define Package/admin/install
	make DESTDIR=$(1) install
endef

$(eval $(call BuildPackage,admin))
