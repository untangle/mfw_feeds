include $(TOPDIR)/rules.mk

PKG_NAME:=backup-scripts
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/backup-scripts
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Cloud
  TITLE:=Backup scripts for MFW
  URL:=https://github.com/untangle/mfw_feeds
  DEPENDS:= +curl
endef

define Package/backup-scripts/description
	This contains the backup scripts for MFW
endef

define Build/Compile
endef

define Package/backup-scripts/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/upload-backup.sh $(1)/usr/bin/
endef

$(eval $(call BuildPackage,backup-scripts))
