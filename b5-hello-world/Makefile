include $(TOPDIR)/rules.mk

PKG_NAME:=b5-hello-world
PKG_LICENSE:=N/A
PKG_MAINTAINER:=John Sommerville (jsommerville@untangle.com)

include ../version.mk

include $(INCLUDE_DIR)/package.mk
# FIXME: standardize on OpenWRT+golang macros, ideally we wouldn't
# have to define anything special in neither Build/Compile nor
# Package/packetd/install
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/b5-hello-world
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=B5 Hello World Proof of Concept
  URL:=https://github.com/
  PKG_BUILD_DEPENDS:=b5-cli
  DEPENDS:=
endef

define Package/b5-hello-world/description
	B5 Hello World Proof of Concept
endef

OUR_SRC_DIR:=$(GO_PKG_BUILD_DIR)/src/$(GO_PKG)

define Build/Compile
	b5 job run --rm -o barney.tar barney.ci/barney%static
endef

define Package/b5-hello-world/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(OUR_SRC_DIR)/cmd/packetd/packetd_rules $(1)/usr/bin/
endef

$(eval $(call BuildPackage,b5-hello-world))
