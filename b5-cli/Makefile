include $(TOPDIR)/rules.mk

PKG_NAME:=b5-cli
PKG_LICENSE:=N/A
PKG_MAINTAINER:=John Sommerville (jsommerville@untangle.com)

include ../version.mk

include $(INCLUDE_DIR)/package.mk
# FIXME: standardize on OpenWRT+golang macros, ideally we wouldn't
# have to define anything special in neither Build/Compile nor
# Package/packetd/install
include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/b5-cli
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=B5 Package tooling to enable B5 packages in mfw_feeds
  URL:=https://github.com/
  PKG_BUILD_DEPENDS:=golang
  DEPENDS:=
endef

define Package/b5-cli/description
	B5 Package tooling to enable B5 packages in mfw_feeds
endef

OUR_SRC_DIR:=$(GO_PKG_BUILD_DIR)/src/$(GO_PKG)

define Build/Compile
	go install barney.ci/apiserver/cmd/b5
	b5 cluster set prod --url=https://barney-api.infra.corp.arista.io
	b5 context set prod --cluster=prod
	b5 context select prod
endef

define Package/b5-cli/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(OUR_SRC_DIR)/cmd/packetd/packetd_rules $(1)/usr/bin/
endef

$(eval $(call BuildPackage,b5-cli))
