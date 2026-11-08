#
# Copyright (C) 2007-2014 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#
# Samba 3.6 file server, revived from OpenWrt 19.07 (where it was dropped
# afterwards) and adapted to current toolchains (GCC 13/14, musl 1.2 with
# 64-bit time_t). Small footprint: one multicall binary, SMB1/SMB2.0.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=samba
PKG_VERSION:=3.6.25
PKG_RELEASE:=15

PKG_SOURCE_URL:=https://download.samba.org/pub/samba \
		https://download.samba.org/pub/samba/stable
PKG_SOURCE:=$(PKG_NAME)-$(PKG_VERSION).tar.gz
PKG_HASH:=8f2c8a7f2bd89b0dfd228ed917815852f7c625b2bc0936304ac3ed63aaf83751

PKG_LICENSE:=GPL-3.0
PKG_LICENSE_FILES:=COPYING
PKG_CPE_ID:=cpe:/a:samba:samba

PKG_BUILD_PARALLEL:=1

include $(INCLUDE_DIR)/package.mk

MAKE_PATH:=source3
CONFIGURE_PATH:=source3

PKG_BUILD_BIN:=$(PKG_BUILD_DIR)/$(MAKE_PATH)/bin

define Package/samba/Default
  SECTION:=net
  CATEGORY:=Network
  TITLE:=Samba 3.6 SMB/CIFS
  URL:=https://www.samba.org/
  MAINTAINER:=Schimmelreiter
endef

define Package/samba36-server
  $(call Package/samba/Default)
  TITLE+= server
  DEPENDS:=+USE_GLIBC:librt $(ICONV_DEPENDS)
endef

define Package/samba36-hotplug
  $(call Package/samba/Default)
  TITLE+= hotplug script for auto sharing
  DEPENDS:=+blockd
endef

define Package/samba36-server/config
	config PACKAGE_SAMBA_MAX_DEBUG_LEVEL
		int "Maximum level of compiled-in debug messages"
		depends on PACKAGE_samba36-server || PACKAGE_samba36-client
		default -1
endef

define Package/samba36-server/description
 The Samba software suite is a collection of programs that implements the
 SMB protocol for UNIX systems, allowing you to serve files and printers to
 Windows, NT, OS/2 and DOS clients. This protocol is sometimes also referred
 to as the LanManager or Netbios protocol.
endef

# Samba 3.6 predates GCC 10/14: it relies on common symbols and on implicit
# declarations/conversions that are errors by default now.
TARGET_CFLAGS += -std=gnu99 -fcommon \
	-Wno-error=implicit-function-declaration -Wno-error=implicit-int \
	-Wno-error=incompatible-pointer-types -Wno-error=int-conversion
# GCC 14+ turns the remaining legacy constructs into errors; -fpermissive
# downgrades them again (the option does not exist for C before GCC 14).
ifeq ($(shell [ "$(firstword $(subst ., ,$(CONFIG_GCC_VERSION)))" -ge 14 ] 2>/dev/null && echo y),y)
  TARGET_CFLAGS += -fpermissive
endif

TARGET_CFLAGS += -DMAX_DEBUG_LEVEL=$(CONFIG_PACKAGE_SAMBA_MAX_DEBUG_LEVEL) -D__location__=\\\"\\\" -ffunction-sections -fdata-sections
TARGET_LDFLAGS += -Wl,--gc-sections

CONFIGURE_VARS += \
	ac_cv_lib_attr_getxattr=no \
	ac_cv_search_getxattr=no \
	ac_cv_file__proc_sys_kernel_core_pattern=yes \
	libreplace_cv_HAVE_C99_VSNPRINTF=yes \
	libreplace_cv_HAVE_GETADDRINFO=yes \
	libreplace_cv_HAVE_IFACE_IFCONF=yes \
	$(if $(CONFIG_IPV6),,libreplace_cv_HAVE_IPV6=no libreplace_cv_HAVE_IPV6_V6ONLY=no) \
	LINUX_LFS_SUPPORT=yes \
	samba_cv_CC_NEGATIVE_ENUM_VALUES=yes \
	samba_cv_HAVE_GETTIMEOFDAY_TZ=yes \
	samba_cv_HAVE_IFACE_IFCONF=yes \
	samba_cv_HAVE_KERNEL_OPLOCKS_LINUX=yes \
	samba_cv_HAVE_SECURE_MKSTEMP=yes \
	samba_cv_HAVE_WRFILE_KEYTAB=no \
	samba_cv_USE_SETREUID=yes \
	samba_cv_USE_SETRESUID=yes \
	samba_cv_have_setreuid=yes \
	samba_cv_have_setresuid=yes \
	ac_cv_header_libunwind_h=no \
	ac_cv_header_zlib_h=no \
	samba_cv_zlib_1_2_3=no \
	ac_cv_path_PYTHON="" \
	ac_cv_path_PYTHON_CONFIG=""

CONFIGURE_ARGS += \
	--exec-prefix=/usr \
	--prefix=/ \
	--disable-avahi \
	--disable-cups \
	--disable-external-libtalloc \
	--disable-external-libtdb \
	--disable-external-libtevent \
	--disable-pie \
	--disable-relro \
	--disable-static \
	--disable-swat \
	--disable-shared-libs \
	--with-libiconv="$(ICONV_PREFIX)" \
	--with-codepagedir=/etc/samba \
	--with-configdir=/etc/samba \
	--with-included-iniparser \
	--with-included-popt \
	--with-lockdir=/var/lock \
	--with-logfilebase=/var/log \
	--with-nmbdsocketdir=/var/nmbd \
	--with-piddir=/var/run \
	--with-privatedir=/etc/samba \
	--with-sendfile-support \
	--without-acl-support \
	--without-cluster-support \
	--without-ads \
	--without-krb5 \
	--without-ldap \
	--without-pam \
	--without-winbind \
	--without-libtdb \
	--without-libtalloc \
	--without-libnetapi \
	--without-libsmbclient \
	--without-libsmbsharemodes \
	--without-libtevent \
	--without-libaddns \
	--with-shared-modules=pdb_tdbsam,pdb_wbc_sam,idmap_nss,nss_info_template,auth_winbind,auth_wbc,auth_domain

MAKE_FLAGS += DYNEXP= PICFLAG= MODULES=

define Package/samba36-server/conffiles
/etc/config/samba
/etc/samba/smb.conf.template
/etc/samba/smbpasswd
endef

define Package/samba36-server/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/samba.config $(1)/etc/config/samba
	$(INSTALL_DIR) $(1)/etc/samba
	$(INSTALL_CONF) ./files/smb.conf.template $(1)/etc/samba
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/codepages/lowcase.dat $(1)/etc/samba
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/codepages/upcase.dat $(1)/etc/samba
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/codepages/valid.dat $(1)/etc/samba
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/samba.init $(1)/etc/init.d/samba
	$(INSTALL_DIR) $(1)/etc/config.readme
	$(INSTALL_DATA) ./files/samba.readme $(1)/etc/config.readme/samba.readme
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_BIN)/samba_multicall $(1)/usr/sbin
	$(LN) samba_multicall $(1)/usr/sbin/smbd
	$(LN) samba_multicall $(1)/usr/sbin/nmbd
	$(LN) samba_multicall $(1)/usr/sbin/smbpasswd
endef

define Package/samba36-hotplug/install
	$(INSTALL_DIR) $(1)/etc/hotplug.d/mount
	$(INSTALL_CONF) ./files/samba.hotplug $(1)/etc/hotplug.d/mount/60-samba
endef

$(eval $(call BuildPackage,samba36-server))
$(eval $(call BuildPackage,samba36-hotplug))

