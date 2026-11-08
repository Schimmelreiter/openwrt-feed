# openwrt-feed

Personal OpenWrt package feed by Schimmelreiter. All packages are built by
GitHub Actions with the official OpenWrt SDK containers
([.github/workflows/build.yml](.github/workflows/build.yml)).

| Package | Description |
|---|---|
| `llmnrd` | LLMNR (RFC 4795) name responder, so Windows finds the device by name |
| `lltd` | LLTD responder for the Windows network map and LLTD mappers ([source](https://github.com/Schimmelreiter/lltd)) |
| `samba36-server`, `samba36-hotplug` | Samba 3.6 file server (small, SMB1/SMB2.0), revived from OpenWrt 19.07 |
| `luci-app-samba`, `luci-i18n-samba-de` | LuCI page for samba36-server, including the WS-Discovery settings |
| `wsdd2` | WS-Discovery responder (Windows "Network" folder), patched: URLs and device category in `-b` |

## Build targets

| OpenWrt | Architecture | Package format | Devices |
|---|---|---|---|
| 25.12 | `arm_cortex-a9_vfpv3-d16` | apk | Linksys WRT1900ACS (mvebu) |
| 24.10 | `mipsel_24kc` | ipk | Cudy AP1300 (ramips mt7621) |

More targets can be added to the matrix in the workflow.

## Download

Every push to `main` publishes the packages

* as releases `packages-<openwrt release>-<arch>`, and
* on the branch [`packages`](../../tree/packages) (`<openwrt release>/<arch>/`).

Build logs of the last run are on the branch [`logs`](../../tree/logs).

## Installation

The packages are not signed with an OpenWrt key.

OpenWrt 25.12 (apk):

```sh
cd /tmp
wget https://github.com/Schimmelreiter/openwrt-feed/releases/download/packages-openwrt-25.12-arm_cortex-a9_vfpv3-d16/<file>.apk
apk add --allow-untrusted /tmp/<file>.apk
```

OpenWrt 24.10 (ipk):

```sh
cd /tmp
wget https://github.com/Schimmelreiter/openwrt-feed/releases/download/packages-openwrt-24.10-mipsel_24kc/<file>.ipk
opkg install /tmp/<file>.ipk
```

## Using it as a feed in your own SDK/buildroot

```
src-git schimmelreiter https://github.com/Schimmelreiter/openwrt-feed.git
```

## Notes

* `samba36-server` starts `wsdd2` itself when it is installed (option `wsdd2`
  in `/etc/config/samba`, default on). Name, workgroup and interface are the
  ones Samba uses. If `llmnrd` is enabled, wsdd2 runs without its own LLMNR
  responder (`-w`), so both do not fight over UDP port 5355.
* Each package documents its UCI options in `/etc/config.readme/<name>.readme`.
