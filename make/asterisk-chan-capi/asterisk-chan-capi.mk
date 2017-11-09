$(call PKG_INIT_BIN, 959)
$(PKG)_NAME_NO_HYPHEN:=$(subst -,,$(pkg))
$(PKG)_SOURCE:=$($(PKG)_NAME_NO_HYPHEN)-$($(PKG)_VERSION).tar.xz
$(PKG)_SITE:=svn://svn.chan-capi.org/chan-capi/trunk

$(PKG)_DEPENDS_ON += libcapi asterisk

$(PKG)_BINARY := $($(PKG)_DIR)/chan_capi.so
$(PKG)_BINARY_TARGET := $($(PKG)_DEST_DIR)/$(ASTERISK_MODULES_DIR)/chan_capi.so

$(PKG)_CONFIG := $($(PKG)_DIR)/capi.conf
$(PKG)_CONFIG_TARGET := $($(PKG)_DEST_DIR)/$(ASTERISK_CONFIG_DIR)/capi.conf

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_ASTERISK_LOWMEMORY
$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_ASTERISK_DEBUG

$(PKG)_MAKE_OPTIONS := -C $(ASTERISK_CHAN_CAPI_DIR)
$(PKG)_MAKE_OPTIONS += OSNAME=Linux
$(PKG)_MAKE_OPTIONS += CC="$(TARGET_CC)"
$(PKG)_MAKE_OPTIONS += OPTIMIZE="$(TARGET_CFLAGS) $(if $(FREETZ_PACKAGE_ASTERISK_DEBUG),$(ASTERISK_DEBUG_CFLAGS))"
$(PKG)_MAKE_OPTIONS += USE_OWN_LIBCAPI=no
$(PKG)_MAKE_OPTIONS += INSTALL_PREFIX="$(ASTERISK_INSTALL_DIR_ABSOLUTE)"
$(PKG)_MAKE_OPTIONS += V=1

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) $(ASTERISK_CHAN_CAPI_MAKE_OPTIONS)

$($(PKG)_CONFIG): $($(PKG)_DIR)/.configured
	touch $@

$($(PKG)_BINARY_TARGET): $($(PKG)_BINARY)
	$(if $(FREETZ_PACKAGE_ASTERISK_DEBUG),$(INSTALL_FILE),$(INSTALL_BINARY_STRIP))

$($(PKG)_CONFIG_TARGET): $($(PKG)_CONFIG)
	$(INSTALL_FILE)

$(pkg):

$(pkg)-precompiled: $($(PKG)_BINARY_TARGET) #$($(PKG)_CONFIG_TARGET)

$(pkg)-clean:
	-$(SUBMAKE) $(ASTERISK_CHAN_CAPI_MAKE_OPTIONS) clean

$(pkg)-uninstall:
	$(RM) $(ASTERISK_CHAN_CAPI_BINARY_TARGET) $(ASTERISK_CHAN_CAPI_CONFIG_TARGET)

$(PKG_FINISH)
