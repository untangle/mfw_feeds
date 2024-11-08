#
# Build BrightCloud daemon for use with MFW
#
include $(TOPDIR)/rules.mk

PKG_NAME:=bctid
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/bctid.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/bctid
  SECTION:=ui
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=Brightcloud classification daemon
  URL:=https://github.com/untangle/bctid
  DEPENDS:=+libidn2 +libstdcpp +libopenssl +zlib +cJSON
endef

define Package/bctid/description
  Brightcloud classification daemon
endef

define Build/Compile
	cd $(PKG_BUILD_DIR) ; \
	$(TARGET_CONFIGURE_OPTS) $(MAKE)
endef

TMP_BUILD_DIR:=$(PKG_BUILD_DIR)/tmp/

define Package/bctid/install
	# Copy bctid categories file
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_BIN) files/categories.json $(1)/etc/config/categories.json

	$(INSTALL_DIR) $(1)/usr/bin $(1)/usr/lib/bctid $(1)/usr/share/bctid
	$(INSTALL_BIN) $(TMP_BUILD_DIR)/src/bin/bctid $(1)/usr/bin/
	$(CP) $(TMP_BUILD_DIR)/src/bin/bcti.cfg $(1)/usr/share/bctid/
	$(CP) $(TMP_BUILD_DIR)/src/lib/* $(1)/usr/lib/bctid
	$(CP) $(TMP_BUILD_DIR)/src/database/* $(1)/usr/share/bctid/

	# Init script
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/bctid.init $(1)/etc/init.d/bctid

	# Modify bcti.cfg template for our licensed services
	$(PKG_BUILD_DIR)/update_bcti_cfg.sh $(1)/usr/share/bctid/bcti.cfg
endef

$(eval $(call BuildPackage,bctid))
