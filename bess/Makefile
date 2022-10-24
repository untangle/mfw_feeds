#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=bess

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:NetSys/bess.git
PKG_LICENSE:=GPL-2.0+

include ../version.mk


PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk


define Package/bess
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+liblzma +zlib +libpcap +libssl +libnuma +git +libprotobuf-c +numactl
  TITLE:=Low-level netlink library for the nf_tables subsystem
  URL:=http://www.netfilter.org/projects/libnftnl
endef

define Package/bess/description
	Bess is a thing.
endef

define Package/bess/install
	echo ehello world
endef

TARGET_CFLAGS += $(FPIC)

# CONFIGURE_ARGS += \
# 	--enable-static \
# 	--enable-shared \
# 	--without-json-parsing

define Build/Compile
	cd $(PKG_BUILD_DIR);	\
	ls -la	;		\
	./build.py
endef

$(eval $(call BuildPackage,bess))
