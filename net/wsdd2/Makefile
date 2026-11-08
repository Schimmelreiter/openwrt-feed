# wsdd2 - WS-Discovery (and LLMNR) responder for Windows network browsing
#
# Same source as the official OpenWrt package, plus a patch for URLs and
# the device category in the -b option. A higher PKG_RELEASE than the
# official package makes apk/opkg prefer this build.
#
# When samba36-server (this feed) is installed, the samba init script runs
# wsdd2 itself (name, workgroup and interfaces from /etc/config/samba);
# the wsdd2 init script then stays idle.

include $(TOPDIR)/rules.mk

PKG_NAME:=wsdd2
PKG_RELEASE:=10

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL:=https://github.com/Netgear/wsdd2.git
PKG_SOURCE_DATE:=2023-12-21
PKG_SOURCE_VERSION:=b676d8ac8f1aef792cb0761fb68a0a589ded3207
PKG_MIRROR_HASH:=f91c011746cab42dbc638f2c049d4be2e882b220adca7ba88c6d14fd2d0c3e7e

PKG_MAINTAINER:=Schimmelreiter
PKG_LICENSE:=GPL-3.0-only
PKG_LICENSE_FILES:=COPYING

include $(INCLUDE_DIR)/package.mk

define Package/wsdd2
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=IP Addresses and Names
  TITLE:=Web Services for Devices (WSD) daemon
  URL:=https://github.com/Netgear/wsdd2
endef

define Package/wsdd2/description
  Web Services for Devices or Web Services on Devices (WSD),
  is a Microsoft API to simplify programming connections to web service
  enabled devices, such as printers, scanners and file shares.

  This daemon advertises and responds to probe requests from Windows clients
  looking for file shares. It also implements LLMNR multicast name lookup.
  Integrated with samba36-server from this feed.
endef

define Build/Compile
  $(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) $(PKG_BUILD_DIR)/{wsdd2.c,wsd.c,llmnr.c} -o $(PKG_BUILD_DIR)/wsdd2
endef

define Package/wsdd2/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/wsdd2 $(1)/usr/bin/
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/wsdd2.init $(1)/etc/init.d/wsdd2
endef

$(eval $(call BuildPackage,wsdd2))
