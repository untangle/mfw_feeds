#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
PKG_MIRROR_HASH:=42f74667e5d2fa36881f6e3aa05ff4772316c5e813cae52b96f1879b17bb6ae2
PKG_NAME:=dpdk
PKG_SOURCE_VERSION:=v19.11
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/DPDK/dpdk.git


PKG_MAINTAINER:=Zbynek Kocur <zbynek.kocur@fel.cvut.cz>
PKG_LICENSE:=BSD-3-Clause
PKG_LICENSE_FILES:=COPYING

PKG_BUILD_DEPENDS:=meson/host python3/host python3-pyelftools/host  

HOST_BUILD_DEPENDS:=meson/host python3/host python3-pyelftools/host python3-distutils/host

#export PYTHONPATH=$(STAGING_DIR_ROOT)/usr/lib64/python3.7/site-packages
HOST_PYTHON3_PACKAGE_BUILD_DEPENDS:="python3-pyelftools"

PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/devel/meson/meson.mk

MESON_ARGS+=-Denable_docs=false -Dexamples=all
CFLAGS+=-D_GNU_SOURCE -g
TARGET_CFLAGS+=-msse4.2
#EXTRA_CFLAGS=-D_GNU_SOURCE -g -O0

# Possible place for CPU ARCH tune:
# nocona core2 nehalem corei7 westmere sandybridge corei7-avx
# ivyzt0bridge core-avx-i haswell core-avx2 broadwell skylake
# skylake-avx512 cannonlake icelake-client icelake-server bonnell
# atom silvermont slm knl knm x86-64 eden-x2 nano nano-1000 nano-2000
# nano-3000 nano-x2 eden-x4 nano-x4 k8 k8-sse3 opteron opteron-sse3 athlon64
# athlon64-sse3 athlon-fx amdfam10 barcelona bdver1 bdver2 bdver3 bdver4
# znver1 btver1 btver2 native
#
# native - works on all x86_64 platforms
#
CONFIG_TARGET_SUBTARGET:="atom"
MESON_CPU:="atom"

define Package/libdpdk
  SECTION:=libs
  CATEGORY:=Libraries
  DEPENDS:=+libnuma +libpcap +libopenssl +zlib +jansson +python3-pyelftools +libelf +libbpf +libatomic +libbsd
  KCONFIG:=CONFIG_NUMA=y \
		CONFIG_HUGETLB_PAGE=y CONFIG_HUGETLBFS=y \
		CONFIG_KERNEL_HUGETLB_PAGE=y CONFIG_KERNEL_PROC_PAGE_MONITOR=y CONFIG_KERNEL_DEV_PAGEMAP_OPS=y \
		CONFIG_KERNEL_PROC_FS=y CONFIG_PAGE_MONITOR=y CONFIG_MMU=y CONFIG_NUMA=y CONFIG_UIO=y CONFIG_VFIO=y\
		CONFIG_VFIO_IOMMU_TYPE1=y CONFIG_VFIO_VIRQFD=y CONFIG_VFIO=y CONFIG_VFIO_NOIOMMU=y CONFIG_VFIO_PCI=y CONFIG_VFIO_PCI_MMAP=y \
		CONFIG_VFIO_PCI_IGD=y CONFIG_VFIO_PCI_INTX=y CONFIG_VHOST=y CONFIG_VHOST_CROSS_ENDIAN_LEGACY=y CONFIG_VHOST_NET=y \
		CONFIG_PACKAGE_libnuma=y CONFIG_PACKAGE_numactl=y CONFIG_VIRTUALIZATION=y CONFIG_IOMMU_API=y
  TITLE:=Set of libraries and drivers for fast packet processing
  URL:=https://www.dpdk.org
endef

define Package/libdpdk/description
  DPDK is a set of libraries and drivers for fast packet processing.
It supports many processor architectures and both FreeBSD and Linux.
endef

define Package/dpdk-tools
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libdpdk +@KERNEL_HUGETLB_PAGE +python3-light +pciutils
  TITLE:=Set of tools for fast packet processing based on DPDK
  URL:=https://www.dpdk.org
endef

define Package/dpdk-tools/description
  DPDK is a set of libraries and drivers for fast packet processing.
It supports many processor architectures and both FreeBSD and Linux.
endef

define Package/dpdk-examples
  SECTION:=net
  CATEGORY:=Network
  DEPENDS:=+libdpdk
  TITLE:=DPDK Example Programs
  URL:=https://www.dpdk.org
endef

define Package/dpdk-examples/description
	This package contains all the dpdk examples, which will be installed into /usr/bin/dpdk-examples/
	DPDK is a set of libraries and drivers for fast packet processing.
	It supports many processor architectures and both FreeBSD and Linux.
endef

define Build/InstallDev
	$(INSTALL_DIR) $(1)/usr/include
	$(CP) $(PKG_INSTALL_DIR)/usr/include/rte_*.h $(1)/usr/include/

	$(INSTALL_DIR) $(1)/usr/include/generic/
	$(CP) $(PKG_INSTALL_DIR)/usr/include/generic/rte_*.h $(1)/usr/include/generic/

	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/{librte_*.a,librte_*.so*,*dpdk*} $(1)/usr/lib/

	$(INSTALL_DIR) $(1)/usr/lib/pkgconfig
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/pkgconfig/libdpdk*.pc $(1)/usr/lib/pkgconfig/
endef


define Package/libdpdk/install
	$(INSTALL_DIR) $(1)/usr/lib
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/lib/librte_*.so.* $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/{librte_*.a,librte_*.so*,dpdk,lib*} $(1)/usr/lib/
endef

define Package/dpdk-tools/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dpdk-devbind.py $(1)/usr/bin/dpdk-devbind
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dpdk-pdump $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dpdk-proc-info $(1)/usr/bin/
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/dpdk-testpmd $(1)/usr/bin/
endef

define Package/dpdk-examples/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_DIR) $(1)/usr/bin/dpdk-examples/

endef

$(eval $(call HostBuild))
$(eval $(call BuildPackage,libdpdk))
$(eval $(call BuildPackage,dpdk-tools))
