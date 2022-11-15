include $(TOPDIR)/rules.mk

PKG_NAME:=wan-utils
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=John Phillips <jphillips@arista.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/wan-utils.git

include ../version.mk
include $(INCLUDE_DIR)/package.mk

GO_PKG:=github.com/untangle/wan-utils
GO_PKG_INSTALL_EXTRA:=Makefile

PKG_BUILD_DEPENDS:=golang/host

# FIXME: standardize on OpenWRT+golang macros, ideally we wouldn't
# have to define anything special in neither Build/Compile nor
# Package/packetd/install
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/wan-utils
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=wan utilities
  URL:=https://github.com/untangle/wan-utils
endef

define Package/wan-utils/description
	wan-manager utilities
endef

OUR_SRC_DIR:=$(GO_PKG_BUILD_DIR)/src/$(GO_PKG)

define Build/Compile
	cd $(OUR_SRC_DIR) ;				\
	export GOPATH=$(GO_PKG_BUILD_DIR)		\
                        GOCACHE=$(GO_PKG_CACHE_DIR)	\
                        GOTMPDIR=$(GO_PKG_TMP_DIR)	\
                        GOROOT_FINAL=$(GO_TARGET_ROOT)	\
                        CC=$(TARGET_CC)		\
                        CXX=$(TARGET_CXX)	\
                        $(call GoPackage/Environment) ; \
	make GOFLAGS=$(MFW_GOFLAGS) build
endef

define Package/wan-utils/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(OUR_SRC_DIR)/cmd/handle_down_interface $(1)/usr/bin/
endef

$(eval $(call BuildPackage,wan-utils))
