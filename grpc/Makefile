################################################################################
#
# grpc
#
################################################################################
include $(TOPDIR)/rules.mk

PKG_NAME:=grpc
PKG_SOURCE_VERSION:= v1.49.1
PKG_SOURCE_PROTO:=git
PKG_MIRROR_HASH:=skip
PKG_SOURCE_URL:=https://github.com/grpc/grpc.git
PKG_LICENSE := Apache-2.0, BSD-3-Clause (third_party code), MPL-2.0 (etc/roots.pem)
CMAKE_INSTALL:=1

include $(INCLUDE_DIR)/package.mk
include $(INCLUDE_DIR)/host-build.mk
include $(INCLUDE_DIR)/cmake.mk
GRPC_INSTALL_STAGING = YES

PKG_BUILD_DEPENDS := protobuf libopenssl grpc/host protobuf/host
HOST_BUILD_DEPENDS := protobuf protobuf/host
define Package/grpc
	DEPENDS:= +libcares +libabseil-cpp +libopenssl +protobuf +re2 +zlib
	SECTIONS:=libs
	CATEGORY:=libraries
	TITLE:=GRPC does the thing.
endef

TARGET_CFLAGS += $(FPIC) -mno-avx

CMAKE_OPTIONS += -DCMAKE_BUILD_TYPE=Release

# This cmake config is mostly copied from buildroot. We set the
# providers to 'package' so it doesn't clone a submodule and build
# some version we don't have. This way it links to provided system
# packages. 'package' means 'cmake', so when there is a 'none'
# package, this means that the library is on the system but may not
# have a cmake file.

# We manually override the protobuf protoc executable because cmake
# finds the target version instead of the host one if left to its own
# devices.
CMAKE_OPTIONS += \
	-DgRPC_PROTOBUF_PROTOC_EXECUTABLE="$(STAGING_DIR_HOSTPKG)/bin/protoc" \
	-DCMAKE_FIND_USE_PACKAGE_ROOT_PATH=FALSE \
	-DgRPC_INSTALL=ON \
	-DgRPC_ABSL_PROVIDER=package \
	-D_gRPC_CARES_LIBRARIES=cares \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_PROTOBUF_PROVIDER=package \
	-DgRPC_RE2_PROVIDER=none \
	-D_gRPC_RE2_LIBRARIES=re2 \
	-DgRPC_SSL_PROVIDER=package \
	-DgRPC_ZLIB_PROVIDER=package \
	-DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PYTHON_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF


# For host-grpc, we only need the 'grpc_cpp_plugin' binary, which is needed for
# target grpc compilation. To avoid unnecessary build steps and host
# dependencies, supply enough options to pass the configure checks without
# requiring other host packages, unless those needed by grpc_cpp_plugin.
CMAKE_HOST_OPTIONS += \
	-DCMAKE_EXE_LINKER_FLAGS="-Wl,-rpath=$(STAGING_DIR_HOSTPKG)/lib" \
	-DCMAKE_FIND_USE_PACKAGE_ROOT_PATH=FALSE \
	-DgRPC_INSTALL=ON \
	-DgRPC_PROTOBUF_PROVIDER=package \
	-DgRPC_ABSL_PROVIDER=none \
	-DgRPC_CARES_PROVIDER=none \
	-DgRPC_RE2_PROVIDER=none \
	-DgRPC_SSL_PROVIDER=none \
	-DgRPC_ZLIB_PROVIDER=none \
	-DgRPC_BUILD_CODEGEN=OFF \
	-DgRPC_BUILD_CSHARP_EXT=OFF \
	-DgRPC_BUILD_PLUGIN_SUPPORT_ONLY=ON \
	-DgRPC_BUILD_GRPC_CSHARP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_NODE_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_OBJECTIVE_C_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PHP_PLUGIN=OFF \
	-DgRPC_BUILD_GRPC_PYTHON_PLUGIN=ON \
	-DgRPC_BUILD_GRPC_RUBY_PLUGIN=OFF

define Package/grpc/install
	$(INSTALL_DIR) $(1)/usr/include/grpc
	$(CP) $(PKG_INSTALL_DIR)/usr/include/grpc/*.h $(1)/usr/include/grpc/
	$(INSTALL_DIR) $(1)/usr/lib
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/*.a $(1)/usr/lib/
	$(INSTALL_DIR) $(1)/usr/lib/cmake
	$(CP) $(PKG_INSTALL_DIR)/usr/lib/cmake/* $(1)/usr/lib/cmake
endef



$(eval $(call HostBuild))
$(eval $(call BuildPackage,grpc))
