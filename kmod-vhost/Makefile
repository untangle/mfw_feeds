#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=vhost
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=Al Parker<al.parker@arista.com>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

MM_MENU=Virtualization

define KernelPackage/vhost
  SUBMENU:=$(MM_MENU)
  TITLE:=VHOST support for PCI devices
  KCONFIG:=\
      CONFIG_HUGETLBFS=y \
      CONFIG_HUGETLB_PAGE=y \
      CONFIG_PROC_PAGE_MONITOR=y \
			CONFIG_VHOST=y \
			CONFIG_VHOST_NET=y
  DEPENDS:=@PCI_SUPPORT @TARGET_x86_64 +kmod-vfio-pci +kmod-tun +libdpdk
  FILES:= \
      $(LINUX_DIR)/drivers/vhost/vhost.ko \
      $(LINUX_DIR)/drivers/vhost/vhost_net.ko
  AUTOLOAD:=$(call AutoProbe,vhost vhost_net)
endef

define KernelPackage/vhost/description
  Support for the vhost driver required by dpdk-testpmd and packetd
endef

define Build/Configure
  true
endef

define Build/Compile
	true
endef

$(eval $(call KernelPackage,vhost))
