# llmnrd - Link-Local Multicast Name Resolution (RFC 4795) responder
#
# Lets Windows clients resolve the router's name via LLMNR without DNS.
# Source: fork of tklauser/llmnrd.

include $(TOPDIR)/rules.mk

PKG_NAME:=llmnrd
PKG_VERSION:=0.7
PKG_RELEASE:=1

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Schimmelreiter/llmnrd.git
PKG_SOURCE_DATE:=2021-11-12
PKG_SOURCE_VERSION:=c1e74297da6f6633805fb9f600ae936915fa56bc
PKG_MIRROR_HASH:=skip

PKG_MAINTAINER:=Schimmelreiter
PKG_LICENSE:=GPL-2.0-only
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/llmnrd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=Link-Local Multicast Name Resolution (LLMNR) daemon
  URL:=https://github.com/Schimmelreiter/llmnrd
endef

define Package/llmnrd/description
  llmnrd answers Link-Local Multicast Name Resolution (RFC 4795) queries,
  so Windows clients can resolve this device's host name on the local
  network without a DNS entry. IPv4 and IPv6 are supported.
endef

define Package/llmnrd/conffiles
/etc/config/llmnrd
endef

MAKE_FLAGS += GIT_VERSION=

define Package/llmnrd/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/llmnrd $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/llmnr-query $(1)/usr/sbin/
	$(INSTALL_DIR) $(1)/etc/init.d $(1)/etc/config
	$(INSTALL_BIN) ./files/llmnrd.init $(1)/etc/init.d/llmnrd
	$(INSTALL_CONF) ./files/llmnrd.config $(1)/etc/config/llmnrd
endef

$(eval $(call BuildPackage,llmnrd))
