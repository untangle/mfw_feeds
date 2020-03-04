include $(TOPDIR)/rules.mk

PKG_NAME:=sync-settings
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/untangle/sync-settings.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk
include ../../packages/lang/python/python3-package.mk

define Package/sync-settings
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python3
  TITLE:=Library for manipulating MFW system settings
  URL:=https://github.com/untangle/sync-settings
  PKG_BUILD_DEPENDS:=python3 python3-urllib3
  DEPENDS:= +diffutils +tc +kmod-sched-core +kmod-sched-cake +kmod-ifb +kmod-sched-connmark\
	  +uuidgen +jsonschema +kmod-nft-fib +openvpn-proto +wireguard +wan-manager +speedtest-cli\
	  +python3 +python3-urllib3
endef

define Package/sync-settings/description
	This module is a Library for manipulating MFW system settings.
endef

define Build/Compile
	$(call Build/Compile/Py3Mod,., \
		install --prefix="/usr" --root="$(PKG_INSTALL_DIR)", )
endef

define Package/sync-settings/install
	$(INSTALL_DIR) $(1)$(PYTHON3_PKG_DIR)
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) \
		$(PKG_INSTALL_DIR)$(PYTHON3_PKG_DIR)/* \
		$(1)$(PYTHON3_PKG_DIR)/
	$(CP) $(PKG_INSTALL_DIR)/usr/bin/* $(1)/usr/bin
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/$(PKG_NAME).init $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_DIR) $(1)/etc/config/startup.d
	$(INSTALL_BIN) files/020-sshd-config $(1)/etc/config/startup.d
	$(INSTALL_BIN) files/nftables-rules.init $(1)/etc/init.d/nftables-rules
	$(INSTALL_BIN) files/qos.init $(1)/etc/init.d/qos
	$(INSTALL_BIN) files/uid.init $(1)/etc/init.d/uid
	$(INSTALL_BIN) files/serial.init $(1)/etc/init.d/serial
	$(INSTALL_BIN) files/startup.init $(1)/etc/init.d/startup
	$(INSTALL_BIN) files/untangle-board-name.init $(1)/etc/init.d/untangle-board-name
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_BIN) files/ifupdown.hotplug $(1)/etc/hotplug.d/iface/20-ifupdown
	$(INSTALL_BIN) files/speedtest.sh $(1)/usr/bin
	$(INSTALL_BIN) files/wwan_status.sh $(1)/usr/bin
	$(INSTALL_BIN) files/nft_debug $(1)/usr/bin
	$(INSTALL_BIN) files/check-for-usb-reset.sh $(1)/usr/bin
endef

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
