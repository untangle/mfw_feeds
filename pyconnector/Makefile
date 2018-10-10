include $(TOPDIR)/rules.mk

PKG_NAME:=pyconnector
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/pyconnector
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
  TITLE:=PyConnector for CMD
  URL:=https://www.github.com/untangle/pyconnector
  URL:=https://untangle.com
  DEPENDS:=+python3
endef

define Package/pyconnector/description
	This is the PyConnector enabling the connection to the CMD cloud
endef

define Build/Compile
endef

define Package/pyconnector/install
	$(INSTALL_BIN) files/pyconnector $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/pyconnector.init $(1)/etc/init.d/pyconnector
endef

$(eval $(call BuildPackage,pyconnector))
