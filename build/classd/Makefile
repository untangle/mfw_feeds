include $(TOPDIR)/rules.mk

PKG_NAME:=classd
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/classd.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/classd
  SECTION:=ui
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=Userspace classification daemon
  URL:=https://github.com/untangle/classd
  PKG_BUILD_DEPENDS:=libstdcpp
  DEPENDS:=+libstdcpp
endef

define Package/classd/description
  Userspace classification daemon
endef

define Package/classd/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/usr/lib $(1)/usr/share/untangle-classd
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/classd $(1)/usr/bin/
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libnavl.so* $(1)/usr/lib/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/share/untangle-classd/protolist.csv $(1)/usr/share/untangle-classd/
endef

$(eval $(call BuildPackage,classd))
