-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2008 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

m = Map("samba", translate("Network Shares"))

s = m:section(TypedSection, "samba", "Samba")
s.anonymous = true

s:tab("general",  translate("General Settings"))
s:tab("wsdd2",    translate("WS-Discovery"))
s:tab("template", translate("Edit Template"))

s:taboption("general", Value, "name", translate("Hostname"))
s:taboption("general", Value, "description", translate("Description"))
s:taboption("general", Value, "workgroup", translate("Workgroup"))
h = s:taboption("general", Flag, "homes", translate("Share home-directories"),
        translate("Allow system users to reach their home directories via " ..
                "network shares"))
h.rmempty = false

ifc = s:taboption("general", DynamicList, "interface", translate("Interfaces"),
	translate("Networks Samba listens on (replaces |INTERFACES| in the template). Default: loopback lan"))
ifc.placeholder = "lan"

-- WS-Discovery (wsdd2): announces the server in the Windows "Network" folder
local has_wsdd2 = nixio.fs.access("/usr/bin/wsdd2")

w = s:taboption("wsdd2", Flag, "wsdd2", translate("Enable WS-Discovery"),
	has_wsdd2 and translate("Announce this server in the Windows \"Network\" folder (wsdd2). Name, workgroup and interface are taken from the general settings.")
		or translate("The package wsdd2 is not installed."))
w.default = "1"
w.rmempty = false

local function wsdd2_opt(name, title, descr, placeholder)
	local o = s:taboption("wsdd2", Value, "wsdd2_" .. name, title, descr)
	o.rmempty = true
	o.placeholder = placeholder
	o:depends("wsdd2", "1")
	function o.validate(self, value)
		if value and value:find(",") then
			return nil, translate("Commas are not allowed.")
		end
		return value
	end
	return o
end

local board = (nixio.fs.readfile("/tmp/sysinfo/model") or ""):gsub("%s+$", "")
local bvendor, bmodel = board:match("^(%S+)%s+(.+)$")

wsdd2_opt("vendor", translate("Manufacturer"), nil, bvendor or board)
wsdd2_opt("model", translate("Model"), nil, bmodel or board)
wsdd2_opt("serial", translate("Serial number"), nil, "0")
wsdd2_opt("sku", translate("SKU"))
wsdd2_opt("vendorurl", translate("Manufacturer URL"))
wsdd2_opt("modelurl", translate("Model URL"))
wsdd2_opt("presentationurl", translate("Presentation URL"),
	translate("Web page of the device, opened from its properties in Windows."), "http://192.168.1.1/")
local cat = wsdd2_opt("category", translate("Device category"),
	translate("PnP-X category that Windows uses for grouping and the icon."), "Computers")
-- suggestions (free input stays possible)
cat:value("Computers")
cat:value("Network.Router")
cat:value("Network.Gateway")
cat:value("Storage")
cat:value("MediaDevices")

tmpl = s:taboption("template", Value, "_tmpl",
	translate("Edit the template that is used for generating the samba configuration."),
	translate("This is the content of the file '/etc/samba/smb.conf.template' from which your samba configuration will be generated. " ..
		"Values enclosed by pipe symbols ('|') should not be changed. They get their values from the 'General Settings' tab."))

tmpl.template = "cbi/tvalue"
tmpl.rows = 20

function tmpl.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/samba/smb.conf.template")
end

function tmpl.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile("//etc/samba/smb.conf.template", value)
end


s = m:section(TypedSection, "sambashare", translate("Shared Directories")
  , translate("Please add directories to share. Each directory refers to a folder on a mounted device."))
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

s:option(Value, "name", translate("Name"))
pth = s:option(Value, "path", translate("Path"))
if nixio.fs.access("/etc/config/fstab") then
        pth.titleref = luci.dispatcher.build_url("admin", "system", "mounts")
end

s:option(Value, "users", translate("Allowed users")).rmempty = true

ro = s:option(Flag, "read_only", translate("Read-only"))
ro.rmempty = false
ro.enabled = "yes"
ro.disabled = "no"

br = s:option(Flag, "browseable", translate("Browseable"))
br.rmempty = false
br.default = "yes"
br.enabled = "yes"
br.disabled = "no"

go = s:option(Flag, "guest_ok", translate("Allow guests"))
go.rmempty = false
go.enabled = "yes"
go.disabled = "no"

cm = s:option(Value, "create_mask", translate("Create mask"),
        translate("Mask for new files"))
cm.rmempty = true
cm.size = 4

dm = s:option(Value, "dir_mask", translate("Directory mask"),
        translate("Mask for new directories"))
dm.rmempty = true
dm.size = 4


return m
