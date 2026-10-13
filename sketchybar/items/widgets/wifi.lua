local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Lock Wi-Fi interface to en0
local interface = "en0"

-- Execute the event provider binary with the Wi-Fi interface
sbar.exec(
	"killall network_load >/dev/null 2>&1; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load "
		.. interface
		.. " network_update 2.0"
)

local popup_width = 250

local wifi_up = sbar.add("item", "widgets.wifi1", {
	position = "right",
	padding_left = -5,
	width = 0,
	icon = {
		padding_right = 0,
		font = {
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		string = icons.wifi.upload,
	},
	label = {
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		color = colors.sora.rose,
		string = "??? Bps",
		width = 55,
	},
	y_offset = 4,
})

local wifi_down = sbar.add("item", "widgets.wifi2", {
	position = "right",
	padding_left = -5,
	icon = {
		padding_right = 0,
		font = {
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		string = icons.wifi.download,
	},
	label = {
		font = {
			family = settings.font.numbers,
			style = settings.font.style_map["Bold"],
			size = 9.0,
		},
		color = colors.sora.cyan,
		string = "??? Bps",
		width = 55,
	},
	y_offset = -4,
})

local wifi = sbar.add("item", "widgets.wifi.padding", {
	position = "right",
	label = { drawing = false },
})

-- Background around the item
local wifi_bracket = sbar.add("bracket", "widgets.wifi.bracket", {
	wifi.name,
	wifi_up.name,
	wifi_down.name,
}, {
	background = { color = colors.bar.bg },
	popup = { align = "center", height = 22 },
})

local ssid = sbar.add("item", {
	position = "popup." .. wifi_bracket.name,
	icon = {
		font = {
			style = settings.font.style_map["Bold"],
		},
		string = icons.wifi.router,
	},
	width = popup_width,
	align = "center",
	label = {
		font = {
			size = 15,
			style = settings.font.style_map["Bold"],
		},
		max_chars = 18,
		string = "????????????",
	},
	background = {
		height = 2,
		color = colors.grey,
		y_offset = -15,
	},
})

local hostname = sbar.add("item", {
	position = "popup." .. wifi_bracket.name,
	icon = {
		align = "left",
		string = "Hostname:",
		width = popup_width / 2,
	},
	label = {
		max_chars = 20,
		string = "????????????",
		width = popup_width / 2,
		align = "right",
	},
})

local ip = sbar.add("item", {
	position = "popup." .. wifi_bracket.name,
	icon = {
		align = "left",
		string = "IP:",
		width = popup_width / 2,
	},
	label = {
		string = "???.???.???.???",
		width = popup_width / 2,
		align = "right",
	},
})

local mask = sbar.add("item", {
	position = "popup." .. wifi_bracket.name,
	icon = {
		align = "left",
		string = "Subnet mask:",
		width = popup_width / 2,
	},
	label = {
		string = "???.???.???.???",
		width = popup_width / 2,
		align = "right",
	},
})

local router = sbar.add("item", {
	position = "popup." .. wifi_bracket.name,
	icon = {
		align = "left",
		string = "Router:",
		width = popup_width / 2,
	},
	label = {
		string = "???.???.???.???",
		width = popup_width / 2,
		align = "right",
	},
})

sbar.add("item", { position = "right", width = settings.group_paddings })

wifi_up:subscribe("network_update", function(env)
	local up_color = (env.upload == "000 Bps") and colors.grey or colors.sora.rose
	local down_color = (env.download == "000 Bps") and colors.grey or colors.sora.cyan
	wifi_up:set({
		icon = { color = up_color },
		label = {
			string = env.upload,
			color = up_color,
		},
	})
	wifi_down:set({
		icon = { color = down_color },
		label = {
			string = env.download,
			color = down_color,
		},
	})
end)

local function check_connection()
	sbar.exec("ipconfig getifaddr " .. interface .. " 2>/dev/null", function(ip_addr)
		local clean_ip = string.gsub(ip_addr, "%s+", "")
		local connected = (clean_ip ~= "")
		wifi:set({
			icon = {
				string = connected and icons.wifi.connected or icons.wifi.disconnected,
				color = connected and (colors.sora and colors.sora.steel or colors.white) or (colors.semantic and colors.semantic.error or colors.red),
			},
		})
	end)
end

wifi:subscribe({ "wifi_change", "system_woke", "forced" }, check_connection)
check_connection()

local function hide_details()
	wifi_bracket:set({ popup = { drawing = false } })
end

local function toggle_details()
	local should_draw = wifi_bracket:query().popup.drawing == "off"
	if should_draw then
		wifi_bracket:set({ popup = { drawing = true } })

		-- Hostname
		sbar.exec("networksetup -getcomputername 2>/dev/null || hostname", function(result)
			hostname:set({ label = string.gsub(result, "%s+$", "") })
		end)

		-- IP
		sbar.exec("ipconfig getifaddr " .. interface .. " 2>/dev/null", function(result)
			local clean = string.gsub(result, "%s+$", "")
			ip:set({ label = (clean ~= "" and clean or "--") })
		end)

		-- SSID (with fallback to avoid <redacted>)
		sbar.exec(
			"SSID=$(networksetup -getairportnetwork " .. interface .. " 2>/dev/null | sed 's/Current Wi-Fi Network: //'); if [ -z \"$SSID\" ] || [ \"$SSID\" = \"<redacted>\" ] || [[ \"$SSID\" == *\"You are not associated\"* ]]; then echo 'Connected'; else echo \"$SSID\"; fi",
			function(result)
				local name = string.gsub(result, "%s+$", "")
				if name == "" then
					name = "No SSID"
				end
				ssid:set({ label = name })
			end
		)

		-- Subnet Mask
		sbar.exec("ipconfig getsummary " .. interface .. " 2>/dev/null | awk -F ' : ' '/subnet_mask/{print $2}'", function(result)
			local clean = string.gsub(result, "%s+$", "")
			mask:set({ label = (clean ~= "" and clean or "255.255.255.0") })
		end)

		-- Router
		sbar.exec("netstat -rn -f inet | awk '/default/{print $2; exit}'", function(result)
			local clean = string.gsub(result, "%s+$", "")
			router:set({ label = (clean ~= "" and clean or "--") })
		end)
	else
		hide_details()
	end
end

wifi_up:subscribe("mouse.clicked", toggle_details)
wifi_down:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.clicked", toggle_details)
wifi:subscribe("mouse.exited.global", hide_details)

local function copy_label_to_clipboard(env)
	local label = sbar.query(env.NAME).label.value
	sbar.exec('echo "' .. label .. '" | pbcopy')
	sbar.set(env.NAME, { label = { string = icons.clipboard, align = "center" } })
	sbar.delay(1, function()
		sbar.set(env.NAME, { label = { string = label, align = "right" } })
	end)
end

ssid:subscribe("mouse.clicked", copy_label_to_clipboard)
hostname:subscribe("mouse.clicked", copy_label_to_clipboard)
ip:subscribe("mouse.clicked", copy_label_to_clipboard)
mask:subscribe("mouse.clicked", copy_label_to_clipboard)
router:subscribe("mouse.clicked", copy_label_to_clipboard)