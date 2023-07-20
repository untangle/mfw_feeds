define MFW/GoPackage/Build/Compile
	cd $(1) ; \
	export GOPATH=$(GO_PKG_BUILD_DIR) \
               GOCACHE=$(GO_PKG_CACHE_DIR) \
               GOTMPDIR=$(GO_PKG_TMP_DIR) \
               GOROOT_FINAL=$(GO_TARGET_ROOT) \
               GOOS="$(GO_OS)" \
               GOARCH="$(GO_ARCH)" \
               GO386="$(GO_386)" \
               GOAMD64="$(GO_AMD64)" \
               GOARM="$(GO_ARM)" \
               GOMIPS="$(GO_MIPS)" \
               GOMIPS64="$(GO_MIPS64)" \
               GOPPC64="$(GO_PPC64)" \
               CGO_ENABLED=1 \
               CC="$(TARGET_CC)" \
               CXX="$(TARGET_CXX)" \
               CGO_CFLAGS="$(filter-out $(GO_CFLAGS_TO_REMOVE),$(TARGET_CFLAGS))" \
               CGO_CPPFLAGS="$(TARGET_CPPFLAGS)" \
               CGO_CXXFLAGS="$(filter-out $(GO_CFLAGS_TO_REMOVE),$(TARGET_CXXFLAGS))" \
               CGO_LDFLAGS="$(TARGET_LDFLAGS)" \
               GOENV=off ; \
	make GOFLAGS=$(MFW_GOFLAGS) build
endef
