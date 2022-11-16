################################################################################
#
# gflags
#
################################################################################
include $(TOPDIR)/rules.mk

PKG_NAME:=gflags
PKG_SOURCE_VERSION:= v2.2.2
PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:= git@github.com:gflags/gflags.git
PKG_MIRROR_HASH:=skip

CMAKE_INSTALL:=1
GFLAGS_INSTALL_STAGING = YES
GFLAGS_LICENSE = BSD-3-Clause
GFLAGS_LICENSE_FILES = COPYING.txt

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/cmake.mk

define Package/gflags
	SECTIONS:=libs
	CATEGORY:=libraries
	TITLE:=glfags flags processing library
	DEPENDS:=+libstdcpp
endef
TARGET_CFLAGS += $(FPIC)
# Force Release otherwise libraries will be suffixed by _debug which will raise
# unexpected build failures with packages that use gflags (e.g. rocksdb)
CMAKE_OPTIONS += -DCMAKE_BUILD_TYPE=Release

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),)
GFLAGS_CONF_OPTS += -DBUILD_gflags_LIB=OFF \
	-DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -DNO_THREADS"
endif

define Package/gflags/install
	$(INSTALL_DIR) $(1)/usr/include/gflags
	$(CP) $(PKG_INSTALL_DIR)/usr/include/gflags/*.h $(1)/usr/include/gflags/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.a $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/cmake
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cmake/* $(1)/usr/lib/cmake
endef
$(eval $(call BuildPackage,gflags))
