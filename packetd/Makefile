#
# Copyright (C) 2016 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=packetd
PKG_VERSION:=0.1.0
PKG_RELEASE:=2018-05-23

PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.xz
PKG_MIRROR_HASH:=b31503be646939003bb1a82671f8b7106644460a
PKG_SOURCE_PROTO:=git
PKG_SOURCE_SUBDIR:=$(PKG_NAME)-$(PKG_VERSION)
PKG_SOURCE_URL:=https://github.com/untangle/packetd.git
PKG_SOURCE_VERSION:=v0.1.0

PKG_MAINTAINER:=Michael Hotz <mahotz@untangle.com>

include $(INCLUDE_DIR)/package.mk

define Package/packetd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  DEPENDS:=+libnetfilter-conntrack +libnetfilter-queue +libnetfilter-log +libnavl +geoip-database \
	  +iptables-mod-nfqueue +iptables-mod-conndict
  # FIXME: needed ?
  KCONFIG:=CONFIG_NETFILTER_NETLINK_GLUE_CT=y CONFIG_NF_CT_NETLINK_HELPER=y \
	  CONFIG_NF_CONNTRACK_DICT=y CONFIG_NF_CONNTRACK_DICT_LIVEPATCH=n
  TITLE:=Userspace packet processing daemon
  URL:=https://www.github.com/untangle/packetd
endef

define Package/packetd/description
	Userspace packet processing daemon
endef

define Build/packetd/Compile
	go build -o $(PKG_BUILD_DIR)/packetd
endef

define Package/packetd/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/update_rules $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/packetd $(1)/usr/bin/
endef

$(eval $(call BuildPackage,packetd))
