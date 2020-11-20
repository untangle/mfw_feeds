include $(TOPDIR)/rules.mk

PKG_NAME:=crash-collector
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Brett Mastbergen <bmastbergen@untangle.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=https://github.com/untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/crash-collector
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Kernel crash log collector
endef

define Package/crash-collector/description
	Collects kernel crashlogs for later analysis
endef

define Build/Compile
endef

define Package/crash-collector/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/crash-collector.init $(1)/etc/init.d/crash-collector
endef

$(eval $(call BuildPackage,crash-collector))
