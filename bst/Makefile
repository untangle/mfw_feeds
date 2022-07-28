include $(TOPDIR)/rules.mk

PKG_NAME:=bst
PKG_VERSION:=1.0.0-rc1
PKG_RELEASE:=$(AUTORELEASE)

PKG_SOURCE_URL:=https://codeload.github.com/aristanetworks/bst/tar.gz/v$(PKG_VERSION)?
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_HASH:=81c7cb5977d0fa8cc0a87fcfb10de705a1baba3761efce557535cc2a1225c2bb

PKG_MAINTAINER:=Arista Networks
PKG_LICENSE:=MIT

PKG_BUILD_DEPENDS:=meson/host python3/host

include $(INCLUDE_DIR)/package.mk
include $(TOPDIR)/feeds/packages/devel/meson/meson.mk

MESON_ARGS+=-Dc_link_args=-static --buildtype=release
CFLAGS+=

CONFIG_TARGET_SUBTARGET:="native"
MESON_CPU:="native"

define Package/bst
	SECTION:=utils
	CATEGORY:=Utilities
	DEPENDS:=
	TITLE:=Arista networks BST (bestie) Namespace encapsulation system
	URL:=github.com/aristanetworks/bst
endef

define Package/bst/description
	bst (pronounced "bestie") is a one-stop shop for running programs in isolated Linux environments. It is, effectively, a combination of unshare, mount, setarch, chroot, and many others; taking care of all the low-level minutæ to get in an environment that is as isolated as possible.
endef

define Package/bst/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_INSTALL_DIR)/usr/bin/bst $(1)/usr/bin/
endef

$(eval $(call BuildPackage,bst))
