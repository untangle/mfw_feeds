include $(TOPDIR)/rules.mk

PKG_NAME:=client-license-service
PKG_LICENSE:=GPL-2.0
PKG_MAINTAINER:=Sebastien Delafond <sdelafond@gmail.com>
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=git@github.com:untangle/client-license-service.git

include ../version.mk

include $(INCLUDE_DIR)/package.mk

include $(INCLUDE_DIR)/../feeds/packages/lang/golang/golang-package.mk

define Package/client-license-service
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=Userspace license client
  URL:=https://github.com/untangle/client-license-service
  PKG_BUILD_DEPENDS:=golang
endef

define Package/client-license-service/description
	Userspace license client
endef

define Build/Compile
	cd $(PKG_BUILD_DIR); \
	export GOPATH=$(GO_PKG_BUILD_DIR) \
                        GOCACHE=$(GO_PKG_CACHE_DIR) \
                        GOTMPDIR=$(GO_PKG_TMP_DIR) \
                        GOROOT_FINAL=$(GO_TARGET_ROOT) \
                        CC=$(TARGET_CC) \
                        CXX=$(TARGET_CXX) \
                        $(call GoPackage/Environment) ; \
  git checkout MFW-1406 \
	go mod tidy; \
	go mod vendor; \
	go build --mod=vendor -ldflags "-X 'main.Version=${VERSION}' -X 'main.IsDev=no'" -o build/client-license-service
endef

define Package/client-license-service/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/build/client-license-service $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) files/clientlic.init $(1)/etc/init.d/clientlic
endef

$(eval $(call BuildPackage,client-license-service))
