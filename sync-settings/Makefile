include $(TOPDIR)/rules.mk

PKG_NAME:=sync-settings
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/sync-settings.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk

define Package/sync-settings
  SECTION:=lang
  CATEGORY:=Languages
  SUBMENU:=Python3
  TITLE:=Library for manipulating MFW system settings
  URL:=https://github.com/untangle/sync-settings
  PKG_BUILD_DEPENDS:=python3-urllib3 python3-pyroute2
  DEPENDS:= +diffutils +tc +kmod-sched +kmod-sched-cake +kmod-ifb +kmod-sched-connmark \
	  +uuidgen +python3-jsonschema +kmod-nft-fib +openvpn-proto +wan-manager +speedtest-cli \
	  +python3 +python3-urllib3 +python3-pyroute2 +python3-requests +strongswan-default +strongswan-mod-gcm \
	  +jq +nmap-ssl +lldpd +kmod-wireguard +wireguard-tools
endef

define Package/sync-settings/description
	This module is a Library for manipulating MFW system settings.
endef

define Py3Package/sync-settings/install
	# bin
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/sync-settings $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/load-eos-config $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/updateSysdbSignal $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/run-eos-command $(1)/usr/bin
	$(INSTALL_BIN) files/speedtest.sh $(1)/usr/bin
	$(INSTALL_BIN) files/wwan_status.sh $(1)/usr/bin
	$(INSTALL_BIN) files/nft_debug $(1)/usr/bin
	$(INSTALL_BIN) files/check-for-usb-reset.sh $(1)/usr/bin
	$(INSTALL_BIN) files/set_affinity.sh $(1)/usr/bin
	$(INSTALL_BIN) files/set_rpsxps.sh $(1)/usr/bin
	$(INSTALL_BIN) files/quota_cron.sh $(1)/usr/bin

	# init.d
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/$(PKG_NAME).init $(1)/etc/init.d/$(PKG_NAME)
	$(INSTALL_BIN) files/nftables-rules.init $(1)/etc/init.d/nftables-rules
	$(INSTALL_BIN) files/qos.init $(1)/etc/init.d/qos
	$(INSTALL_BIN) files/serial.init $(1)/etc/init.d/serial
	$(INSTALL_BIN) files/setup.init $(1)/etc/init.d/setup
	$(INSTALL_BIN) files/startup.init $(1)/etc/init.d/startup
	$(INSTALL_BIN) files/static-routes.init $(1)/etc/init.d/static-routes
	$(INSTALL_BIN) files/uid.init $(1)/etc/init.d/uid
	$(INSTALL_BIN) files/product-board-name.init $(1)/etc/init.d/product-board-name
	$(INSTALL_BIN) files/load-eos-config.init $(1)/etc/init.d/load-eos-config

	# config/startup.d
	$(INSTALL_DIR) $(1)/etc/config/startup.d
	$(INSTALL_BIN) files/020-sshd-config $(1)/etc/config/startup.d

	# FIXME: nothing under config/setup.d?
	$(INSTALL_DIR) $(1)/etc/config/setup.d

	# hotplug.d/iface
	$(INSTALL_DIR) $(1)/etc/hotplug.d/iface
	$(INSTALL_BIN) files/ifupdown.hotplug $(1)/etc/hotplug.d/iface/20-ifupdown
endef

$(eval $(call Py3Package,$(PKG_NAME)))
$(eval $(call BuildPackage,$(PKG_NAME)))
