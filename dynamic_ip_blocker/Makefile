include $(TOPDIR)/rules.mk

PKG_NAME:=dynamic-ip-blocker
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Akshay Abhyankar <aabhyankar@arista.com>
PKG_SOURCE_PROTO:=git
# FIXME: we really don't need *any* source from git right now
PKG_SOURCE_URL:=git@github.com:untangle/mfw_feeds.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

define Package/dynamic-ip-blocker
  SECTION:=net
  CATEGORY:=Network
  TITLE:=IP BLOCKER
  URL:=https://github.com/untangle/mfw_feeds
  DEPENDS:=+python3 +openssh-client +openssh-server +wan-utils +nftables
endef

define Package/dynamic-ip-blocker/description
	Dynamic IP blocking
endef

define Build/Compile
endef

define Package/dynamic-ip-blocker/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/dynamic-ip-blocker $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	# $(INSTALL_BIN) files/dynamic-ip-blocker.init $(1)/etc/init.d/dynamic-ip-blocker
endef

$(eval $(call BuildPackage,dynamic-ip-blocker))
