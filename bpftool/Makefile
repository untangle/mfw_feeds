include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk

PKG_NAME:=bpftool
PKG_VERSION:=$(LINUX_VERSION)
PKG_RELEASE:=1

PKG_BUILD_PARALLEL:=1
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Felix Fietkau <nbd@nbd.name>
PKG_FLAGS:=nonshared

PKG_BUILD_DIR:=$(LINUX_DIR)/tools/bpf-$(TARGET_DIR_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/bpftool
  SECTION:=devel
  CATEGORY:=Development
  TITLE:=Linux bpf inspection tool
  VERSION:=$(LINUX_VERSION)-$(PKG_RELEASe)
  DEPENDS:=+libelf1 +libopcodes +libbfd \
	   +USE_MUSL:musl-fts +USE_MUSL:libpthread
  KCONFIG:=CONFIG_BPF=y CONFIG_BPF_SYSCALL=y \
	   CONFIG_BPF_JIT=y CONFIG_HAVE_EBPF_JIT=y
  URL:=http://www.kernel.org 
endef

define Package/bpftool/description
	Linux bpf inspection tool
endef

define Build/Prepare
	$(CP) $(LINUX_DIR)/tools/bpf/* $(PKG_BUILD_DIR)/
endef

MAKE_FLAGS = \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	CC="$(TARGET_CC)" \
	LD="$(TARGET_CROSS)ld" \
	CFLAGS="$(TARGET_CFLAGS) $(TARGET_CPPFLAGS)" \
	LDFLAGS="$(TARGET_LDFLAGS)" \
	ARCH="$(ARCH)" \
	$(if $(findstring c,$(OPENWRT_VERBOSE)),V=1,V='') \
	WERROR=0 \
	prefix=/usr

define Build/Compile
	+$(MAKE_FLAGS) $(MAKE) $(PKG_JOBS) \
		-C $(PKG_BUILD_DIR) \
		bpftool
endef

define Package/bpftool/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bpftool/bpftool $(1)/usr/bin/
endef

$(eval $(call BuildPackage,bpftool))
