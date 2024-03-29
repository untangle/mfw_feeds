#
# Copyright (C) 2017 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=uio_pci_generic
PKG_RELEASE:=$(AUTORELEASE)

PKG_MAINTAINER:=Zbynek Kocur <zbynek.kocur@fel.cvut.cz>
PKG_LICENSE:=GPL-2.0

include $(INCLUDE_DIR)/package.mk

MM_MENU=Virtualization

define KernelPackage/uio_pci_generic
  SUBMENU:=$(MM_MENU)
  TITLE:=Generic driver for PCI 2.3 and PCI Express cards
  KCONFIG:= \
      CONFIG_UIO=m \
      CONFIG_UIO_CIF=n \
      CONFIG_UIO_PDRV_GENIRQ=n \
      CONFIG_UIO_DMEM_GENIRQ=n \
      CONFIG_UIO_AEC=n \
      CONFIG_UIO_SERCOS3=n \
      CONFIG_UIO_NETX=n \
      CONFIG_UIO_PRUSS=n \
      CONFIG_UIO_MF624=n \
      CONFIG_UIO_HV_GENERIC=n\
      CONFIG_UIO_PCI_GENERIC=m
      DEPENDS:= @TARGET_x86_64 @PCI_SUPPORT
  FILES:= \
      $(LINUX_DIR)/drivers/uio/uio.ko \
      $(LINUX_DIR)/drivers/uio/uio_pci_generic.ko
  AUTOLOAD:=$(call AutoProbe,uio uio_pci_generic)
endef

define KernelPackage/uio_pci_generic/description
  Generic driver that you can bind, dynamically, to any PCI 2.3
compliant and PCI Express card. It is useful, primarily,
for virtualization scenarios.
endef

define Build/Configure
  true
endef

define Build/Compile
  true
endef

$(eval $(call KernelPackage,uio_pci_generic))

