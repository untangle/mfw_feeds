include $(TOPDIR)/rules.mk

PKG_NAME:=bctid
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/ngfw_hades-pkgs.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/bctid
  SECTION:=ui
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=Brightcloud classification daemon
  URL:=https://github.com/untangle/ngfw_hades-pkgs
  DEPENDS:=+libidn2 +libstdcpp +libopenssl
endef

define Package/bctid/description
  Brightcloud classification daemon
endef

define Build/Compile
	cd $(PKG_BUILD_DIR)/untangle-bctid ; \
	git checkout NGFW-13753 ; \
	$(TARGET_CONFIGURE_OPTS) $(MAKE)
endef

TMP_BUILD_DIR:=$(PKG_BUILD_DIR)/untangle-bctid/tmp/bcti-sdk-linux-*

define Package/bctid/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/usr/lib $(1)/usr/share/untangle-bctid
	$(INSTALL_BIN) $(TMP_BUILD_DIR)/bin/bctid $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/bctid.init $(1)/etc/init.d/bctid
	$(INSTALL_BIN) files/bcti.cfg.sdwan $(1)/usr/share/untangle-bctid/bcti.cfg
	$(CP) $(TMP_BUILD_DIR)/lib/* $(1)/usr/lib/
	$(CP) $(TMP_BUILD_DIR)/database/* $(1)/usr/share/untangle-bctid/
endef

$(eval $(call BuildPackage,bctid))
