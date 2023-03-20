include $(TOPDIR)/rules.mk

PKG_NAME:=libpktdpdk
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Al Parker <al.parker@arista.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/libpktdpdk.git

include ../version.mk

PKG_BUILD_DEPENDS:=golang/host

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

CFLAGS+=-D_GNU_SOURCE -g
TARGET_CFLAGS+=-msse4.2
CONFIG_TARGET_SUBTARGET:="atom"

define Package/libpktdpdk
	SECTION:=libs
	CATEGORY:=libraries
	DEPENDS:=+libdpdk +dpdk-tools
	TITLE:=Userspace DPDK packet processing library 
	URL:=https://github.com/untangle/libpktdpdk
endef

define Package/libpktdpdk/description
	Userspace DPDK packet processing library
endef

define Package/libpktdpdk/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/libpktdpdk.so* $(1)/usr/lib/	
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) files/dpdkclient.sh $(1)/usr/bin
endef

$(eval $(call BuildPackage,libpktdpdk))
