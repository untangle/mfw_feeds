include $(TOPDIR)/rules.mk

PKG_NAME:=credentials
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=git@github.com:untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/credentials
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Credentials
  URL:=https://github.com/untangle/mfw_feeds
endef

define Package/credentials/description
	Ensure the credentials.json file exists
endef

define Build/Compile
endef

define Package/credentials/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) files/credentials.json $(1)/etc/config/
endef

$(eval $(call BuildPackage,credentials))
