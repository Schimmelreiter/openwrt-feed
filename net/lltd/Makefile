# lltd - Link Layer Topology Discovery (LLTD) responder
#
# Makes the device appear in the Windows network map and in LLTD mappers.
# Source and documentation: https://github.com/Schimmelreiter/lltd

include $(TOPDIR)/rules.mk

PKG_NAME:=lltd
PKG_VERSION:=1.0.0
PKG_RELEASE:=4

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Schimmelreiter/lltd.git
PKG_SOURCE_DATE:=2026-11-08
PKG_SOURCE_VERSION:=b3a3a74f0827f668d5dfaf3ac3be0225fb7d84e1
PKG_MIRROR_HASH:=skip

PKG_MAINTAINER:=Schimmelreiter
PKG_LICENSE:=GPL-3.0-or-later
PKG_LICENSE_FILES:=LICENSE

include $(INCLUDE_DIR)/package.mk

define Package/lltd
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=Link Layer Topology Discovery (LLTD) responder
  URL:=https://github.com/Schimmelreiter/lltd
endef

define Package/lltd/description
  Responder for the Link Layer Topology Discovery protocol (MS-LLTD):
  the device appears in the Windows network map with name, address,
  medium, speed and icon, and takes part in topology tests. Handles
  bridges with DSA switches (local FDB entries for test addresses).
endef

define Package/lltd/conffiles
/etc/config/lltd
endef

MAKE_FLAGS += VERSION=$(PKG_VERSION) lltd

define Package/lltd/install
	$(INSTALL_DIR) $(1)/usr/sbin $(1)/etc/init.d $(1)/etc/config $(1)/etc/config.readme
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/lltd $(1)/usr/sbin/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/files/openwrt/lltd.init $(1)/etc/init.d/lltd
	$(INSTALL_CONF) $(PKG_BUILD_DIR)/files/openwrt/lltd.config $(1)/etc/config/lltd
	$(INSTALL_DATA) $(PKG_BUILD_DIR)/files/openwrt/lltd.readme $(1)/etc/config.readme/lltd.readme
endef

$(eval $(call BuildPackage,lltd))
