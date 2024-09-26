$(call PKG_INIT_BIN, $(if $(FREETZ_PACKAGE_UNRAR_VERSION_61),6.1.7,$(if $(FREETZ_PACKAGE_UNRAR_VERSION_62),6.2.12,7.0.9)))
$(PKG)_MAJOR_VERSION:=$(call GET_MAJOR_VERSION,$($(PKG)_VERSION))
$(PKG)_SOURCE:=unrarsrc-$($(PKG)_VERSION).tar.gz
$(PKG)_HASH:=$($(PKG)_HASH_$(subst .,,$($(PKG)_MAJOR_VERSION)))
$(PKG)_HASH_61:=de75b6136958173fdfc530d38a0145b72342cf0d3842bf7bb120d336602d88ed
$(PKG)_HASH_62:=a008b5f949bca9bb4ffa1bebbfc8b3c14b89df10a10354809b845232d5f582e5
$(PKG)_HASH_70:=505c13f9e4c54c01546f2e29b2fcc2d7fabc856a060b81e5cdfe6012a9198326
$(PKG)_SITE:=https://www.rarlab.com/rar
### WEBSITE:=https://www.rarlab.com/rar_add.htm
### MANPAGE:=https://linux.die.net/man/1/unrar
### CHANGES:=https://www.rarlab.com/rarnew.htm
### SUPPORT:=fda77

$(PKG)_BINARY:=$($(PKG)_DIR)/unrar
$(PKG)_TARGET_BINARY:=$($(PKG)_DEST_DIR)/usr/bin/unrar

$(PKG)_CONDITIONAL_PATCHES+=$($(PKG)_MAJOR_VERSION)

$(PKG)_DEPENDS_ON += $(STDCXXLIB)
$(PKG)_REBUILD_SUBOPTS += FREETZ_STDCXXLIB

$(PKG)_REBUILD_SUBOPTS += FREETZ_PACKAGE_UNRAR_STATIC
ifeq ($(strip $(FREETZ_PACKAGE_UNRAR_STATIC)),y)
$(PKG)_LDFLAGS := -static
endif

$(PKG)_REBUILD_SUBOPTS += FREETZ_TARGET_UCLIBC_0_9_28
$(PKG)_REBUILD_SUBOPTS += FREETZ_TARGET_UCLIBC_0_9_29
ifeq ($(strip $(or $(FREETZ_TARGET_UCLIBC_0_9_28),$(FREETZ_TARGET_UCLIBC_0_9_29))),y)
$(PKG)_DEFINES += -DVFWPRINTF_WORKAROUND_REQUIRED
endif

$(PKG)_CFLAGS := $(TARGET_CFLAGS)
ifneq ($(strip $(FREETZ_PACKAGE_UNRAR_VERSION_70)),y)
$(PKG)_CFLAGS += -std=gnu++11
$(PKG)_CFLAGS += -fno-rtti
else
$(PKG)_CFLAGS += -fno-rtti
$(PKG)_CFLAGS += -fno-exceptions
endif

$(PKG_SOURCE_DOWNLOAD)
$(PKG_UNPACKED)
$(PKG_CONFIGURED_NOP)

$($(PKG)_BINARY): $($(PKG)_DIR)/.configured
	$(SUBMAKE) -C $(UNRAR_DIR) -f makefile \
		CXX="$(TARGET_CXX)" \
		CXXFLAGS="$(UNRAR_CFLAGS)" \
		LDFLAGS="$(UNRAR_LDFLAGS)" \
		DEFINES="$(UNRAR_DEFINES)" \
		STRIP=true

$($(PKG)_TARGET_BINARY): $($(PKG)_BINARY)
	$(INSTALL_BINARY_STRIP)

$(pkg):

$(pkg)-precompiled: $($(PKG)_TARGET_BINARY)


$(pkg)-clean:
	-$(SUBMAKE) -C $(UNRAR_DIR) -f makefile clean

$(pkg)-uninstall:
	$(RM) $(UNRAR_TARGET_BINARY)

$(PKG_FINISH)
