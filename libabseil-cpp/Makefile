include $(TOPDIR)/rules.mk
PKG_NAME:=libabseil-cpp
PKG_SOURCE_VERSION := 20220623.1
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL := git@github.com:abseil/abseil-cpp.git
PKG_HASH:=skip
PKG_MIRROR_HASH:=skip
PKG_LICENSE := Apache-2.0
PKG_LICENSE_FILES := LICENSE
PKG_INSTALL_STAGING := YES
CMAKE_INSTALL:=1
include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/cmake.mk
GRPC_INSTALL_STAGING = YES

define Package/libabseil-cpp
# Need to use host grpc_cpp_plugin during cross compilation.
	DEPENDS:= +libstdcpp
	SECTION:=libs
	CATEGORY:=libraries
	TITLE:=abseil is where its at.
endef

TARGET_CFLAGS += $(FPIC)

CMAKE_OPTIONS += -DCMAKE_BUILD_TYPE=Release

CMAKE_OPTIONS += \
	-DCMAKE_CXX_STANDARD=11 \
	-DABSL_ENABLE_INSTALL=ON \
	-DABSL_USE_GOOGLETEST_HEAD=OFF

# HOST_LIBABSEIL_CPP_CONF_OPTS = \
# 	-DCMAKE_CXX_STANDARD=11 \
# 	-DABSL_ENABLE_INSTALL=ON \
# 	-DABSL_USE_GOOGLETEST_HEAD=OFF
define Package/libabseil-cpp/install
	$(INSTALL_DIR) $(1)/usr/include/absl
	$(CP) -R $(PKG_INSTALL_DIR)/usr/include/absl/* $(1)/usr/include/absl/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.a $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/cmake
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cmake/* $(1)/usr/lib/cmake
endef

$(eval $(call BuildPackage,libabseil-cpp))
