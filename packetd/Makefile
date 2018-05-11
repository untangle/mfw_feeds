#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=packetd
PKG_RELEASE:=2018-05-09

include $(INCLUDE_DIR)/package.mk

define Package/packetd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  DEPENDS:=+libnetfilter-conntrack +libnetfilter-queue +libnetfilter-log +libnavl +geoip-database \
	  +iptables-mod-nfqueue +iptables-mod-conndict
  KCONFIG:=CONFIG_NETFILTER_NETLINK_GLUE_CT=y CONFIG_NF_CT_NETLINK_HELPER=y \
	  CONFIG_NF_CONNTRACK_DICT=y CONFIG_NF_CONNTRACK_DICT_LIVEPATCH=n
  TITLE:=Userspace packet processing daemon
  VERSION:=$(PKG_RELEASE)
  MAINTAINER:=Michael Hotz <mahotz@untangle.com>
  URL:=https://www.github.com/untangle/packetd
endef

define Package/packetd/description
  Userspace packet processing daemon
endef

define Build/Prepare
	$(CP) src/packetd $(PKG_BUILD_DIR)/
	$(CP) src/update_rules $(PKG_BUILD_DIR)/
endef

define Build/Compile
	true
endef

define Package/packetd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/packetd $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/update_rules $(1)/usr/bin/
endef

$(eval $(call BuildPackage,packetd))
