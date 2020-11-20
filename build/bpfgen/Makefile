include $(TOPDIR)/rules.mk

PKG_NAME:=bpfgen
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Tiffany Kalin <tkalin@untangle.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/untangle/bpfgen.git

include ../version.mk

PKG_FIXUP:=autoreconf
PKG_INSTALL:=1

include $(INCLUDE_DIR)/package.mk

define Package/bpfgen
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=BPF program generator
  URL:=https://github.com/untangle/bpfgen
  DEPENDS:=+libnftnl +libmnl +jansson
  KCONFIG:=CONFIG_BPF=y CONFIG_BPF_SYSCALL=y \
	   CONFIG_BPF_JIT=y CONFIG_HAVE_EBPF_JIT=y 
endef

define Package/bpfgen/description
	BPF program generator
endef

define Package/bpfgen/install
	$(INSTALL_DIR) $(1)/usr/bin $(1)/usr/bin/tests $(1)/usr/bin/tests/tests_bpfgen $(1)/usr/bin/tests/tests_expected_bpf_output
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/bpfgen $(1)/usr/bin/bpfgen
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/test/test_bpfgen $(1)/usr/bin/test_bpfgen
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/test/tests_bpfgen/test_1.json $(1)/usr/bin/tests/tests_bpfgen/test_1.json
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/test/tests_bpfgen/test_2.json $(1)/usr/bin/tests/tests_bpfgen/test_2.json
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/test/tests_expected_bpf_output/test_0 $(1)/usr/bin/tests/tests_expected_bpf_output/test_0
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/test/tests_expected_bpf_output/test_1 $(1)/usr/bin/tests/tests_expected_bpf_output/test_1
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/src/test/tests_expected_bpf_output/test_2 $(1)/usr/bin/tests/tests_expected_bpf_output/test_2
endef

$(eval $(call BuildPackage,bpfgen))
