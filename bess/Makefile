#
# Copyright (C) 2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=bess
PKG_SOURCE_PROTO:=git
PKG_MAINTAINER:=Christian Rasmussen <crasmussen@arista.com>
PKG_SOURCE_URL:=git@github.com:untangle/bess.git
PKG_LICENSE:=GPL-2.0+

include ../version.mk

include $(TOPDIR)/feeds/packages/lang/python/python3-package.mk
include $(INCLUDE_DIR)/package.mk

PKG_BUILD_DEPENDS:=libdpdk

define Package/bess
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libnuma +liblzma +zlib +libpcap +libopenssl +git +libdpdk +libprotobuf-c +glog +libunwind +gflags +grpc +scapy +python3-grpcio +python3-protobuf +kmod-bess +rsync
  TITLE:=Low-level netlink library for the nf_tables subsystem
  URL:=http://www.netfilter.org/projects/libnftnl
  KCONFIG:=CONFIG_NUMA=y \
		CONFIG_HUGETLB_PAGE=y CONFIG_HUGETLBFS=y \
		CONFIG_KERNEL_HUGETLB_PAGE=y CONFIG_KERNEL_PROC_PAGE_MONITOR=y CONFIG_KERNEL_DEV_PAGEMAP_OPS=y \
		CONFIG_KERNEL_PROC_FS=y CONFIG_PAGE_MONITOR=y CONFIG_MMU=y CONFIG_NUMA=y CONFIG_UIO=y \
		CONFIG_VFIO_IOMMU_TYPE1=y CONFIG_VFIO_VIRQFD=y CONFIG_VFIO=y CONFIG_VFIO_NOIOMMU=y CONFIG_VFIO_PCI=y CONFIG_VFIO_PCI_MMAP=y \
		CONFIG_PACKAGE_libnuma=y CONFIG_PACKAGE_numactl=y
endef

define Package/bess/description
	Bess is really the thing.
endef

include $(INCLUDE_DIR)/kernel.mk

define KernelPackage/bess
  TITLE:=BESS kernel modules
  URL:=git@github.com:untangle/bess.git
  FILES:=$(PKG_BUILD_DIR)/core/kmod/bess.ko
endef

include $(INCLUDE_DIR)/kernel-defaults.mk

define KernelPackage/bess/description
	Bess kernel stuff.
endef

TARGET_CFLAGS += $(FPIC) -mno-avx
TARGET_CXXFLAGS += -std=c++17 -msse2 -msse3 -msse4.2 -msse4  -mno-avx


MAKE_VARS += PKG_CONFIG=$(STAGING_DIR_HOST)/bin/pkg-config \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR) \
	BESS_LINK_DYNAMIC=y \
	CPU=atom
MAKE_PATH:=core

# configure generates bess' python protobuf files.
define Build/Configure
	pushd $(PKG_BUILD_DIR); \
	python3 -c 'from build import *; generate_protobuf_files()'; \
	popd;
endef

define Build/Compile
	$(call Build/Compile/Default)
	$(KERNEL_MAKE) M="$(PKG_BUILD_DIR)/core/kmod" modules
endef

define Package/bess/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(CP) -L $(PKG_BUILD_DIR)/bin/* $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/$(PYTHON3_PKG_DIR)/
	$(CP) -LR $(PKG_BUILD_DIR)/bessctl/* $(1)/$(PYTHON3_PKG_DIR)/
	$(CP) -LR $(PKG_BUILD_DIR)/pybess/ $(1)/$(PYTHON3_PKG_DIR)/
endef

define Package/bess-init
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=BESS init script
  URL:=https://www.arista.com
endef

define Package/bess-init/description
  This package contains the bess init script.
endef

define Package/bess-init/install
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/bess.init $(1)/etc/init.d/bess
endef

$(eval $(call BuildPackage,bess))
$(eval $(call BuildPackage,bess-init))
$(eval $(call KernelPackage,bess))
