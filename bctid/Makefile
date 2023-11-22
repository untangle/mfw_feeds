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
  DEPENDS:=+libidn2 +libstdcpp +libopenssl +zlib
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

	# Our base credentials
	sed -i -e  's/\(OEM=\).*/\1Untangle/' $(1)/usr/share/bctid/bcti.cfg
	sed -i -e  's/\(Device=\).*/\1SDWanRouter/' $(1)/usr/share/bctid/bcti.cfg
	sed -i -e  's/\(UID=\).*/\1XXX/' $(1)/usr/share/bctid/bcti.cfg

	# Disable unlicensed services
	sed -i -e  's/\(EnableUrlDb=\).*/\1False/' $(1)/usr/share/bctid/bcti.cfg
	sed -i -e  's/\(EnableIpDb=\).*/\1False/' $(1)/usr/share/bctid/bcti.cfg
	sed -i -e  's/\(EnableMd5=\).*/\1False/' $(1)/usr/share/bctid/bcti.cfg
	sed -i -e  's/\(EnablePhishing=\).*/\1False/' $(1)/usr/share/bctid/bcti.cfg
	sed -i -e  's/\(EnableCDB=\).*/\1False/' $(1)/usr/share/bctid/bcti.cfg
	sed -i -e  's/\(EnableCSI=\).*/\1False/' $(1)/usr/share/bctid/bcti.cfg

	# Logfile
	sed -i -e  's/\(LogFile=\).*/\1\/tmp\/log\/bcti.log/' $(1)/usr/share/bctid/bcti.cfg

	# Database
	sed -i -e  's/\(LocalDatabaseDirectory=\).*/\1\/usr\/share\/bctid/' $(1)/usr/share/bctid/bcti.cfg
	sed -i -e  's/\(TLDPath=\).*/\1\/usr\/share\/bctid\/public_suffix_list.dat/' $(1)/usr/share/bctid/bcti.cfg

	# Upper the connection pool to 25
	sed -i -e  's/\(ThreadPoolSize=\).*/\125/' $(1)/usr/share/bctid/bcti.cfg
	sed -i -e  's/\(ConnectionPoolSize=\).*/\125/' $(1)/usr/share/bctid/bcti.cfg
endef

$(eval $(call BuildPackage,bctid))
