include $(TOPDIR)/rules.mk

PKG_NAME:=pyconnector
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/pyconnector
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
  TITLE:=PyConnector for CMD
  URL:=https://github.com/untangle/mfw_feeds
  DEPENDS:=+python3 +openssh-client +openssh-server
endef

define Package/pyconnector/description
	This is the PyConnector enabling the connection to the CMD cloud
endef

define Build/Compile
endef

define Package/pyconnector/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/pyconnector $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/pyconnector.init $(1)/etc/init.d/pyconnector
endef

$(eval $(call BuildPackage,pyconnector))
