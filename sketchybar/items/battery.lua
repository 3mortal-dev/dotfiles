local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery_percent = sbar.add("item", "widgets.battery1", {
	position = "right",
	icon = { drawing = false },
	update_freq = 120,
	label = {
		string = "??%",
		padding_left = -1,
		font = { family = settings.font.numbers },
	},
})

local battery_icon = sbar.add("item", "widgets.battery2", {
	position = "right",
	padding_right = -1,
	icon = {
		string = icons.battery._100,
		align = "left",
		color = colors.grey,
		font = {
			family = "SF Pro",
			style = "Regular",
			size = 14.0,
		},
	},
	label = { drawing = false },
})

local battery_bracket = sbar.add("bracket", "widgets.battery.bracket", {
	battery_icon.name,
	battery_percent.name,
}, {
	background = { color = colors.bar.bg },
})

sbar.add("item", "widgets.battery.padding", {
	position = "right",
	width = settings.group_paddings,
})

local function update()
	sbar.exec("pmset -g batt", function(batt_info)
		local percent = tonumber(batt_info:match("InternalBattery.-(%d+)%%"))
		if not percent then
			return
		end

		local charging = batt_info:find("AC Power") ~= nil and not batt_info:find("discharging")
		local icon

		if charging then
			icon = icons.battery.charging
		elseif percent <= 10 then
			icon = icons.battery._0
		elseif percent <= 30 then
			icon = icons.battery._25
		elseif percent <= 60 then
			icon = icons.battery._50
		elseif percent <= 85 then
			icon = icons.battery._75
		else
			icon = icons.battery._100
		end

		local color = colors.white
		if percent <= 10 and not charging then
			color = colors.red
		end

		battery_icon:set({ icon = { string = icon, color = color } })
		battery_percent:set({ label = string.format("%02d%%", percent) })
	end)
end

battery_percent:subscribe({ "routine", "power_source_change", "system_woke", "forced" }, update)

update() -- run once on load

return battery_bracket
