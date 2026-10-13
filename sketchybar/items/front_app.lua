local colors = require("colors")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local front_app = sbar.add("item", "front_app", {
	display = "active",
	icon = {
		drawing = true,
		font = "sketchybar-app-font:Regular:16.0",
		color = colors.sora.cyan or colors.blue,
		padding_left = 10,
		padding_right = 10,
	},
	label = {
		drawing = false,
	},
	background = {
		color = colors.bar.bg,
		border_color = colors.bg2,
		border_width = 2,
		height = 28,
		corner_radius = 8,
	},
	padding_left = 4,
	padding_right = 4,
	updates = true,
})

local front_app_bracket = sbar.add("bracket", { front_app.name }, {
	background = {
		color = colors.transparent,
		border_color = colors.bg2,
		height = 30,
		border_width = 2,
	},
})

front_app:subscribe("front_app_switched", function(env)
	local app_name = env.INFO
	local lookup = app_icons[app_name]
	local icon = (lookup == nil and app_icons["default"]) or lookup or "􀣺"

	front_app:set({
		icon = { string = icon },
	})
end)

front_app:subscribe("mouse.entered", function()
	sbar.animate("tanh", 15, function()
		front_app:set({
			background = { border_color = colors.highlight },
		})
		front_app_bracket:set({
			background = { border_color = colors.grey },
		})
	end)
end)

front_app:subscribe("mouse.exited", function()
	sbar.animate("tanh", 15, function()
		front_app:set({
			background = { border_color = colors.bg2 },
		})
		front_app_bracket:set({
			background = { border_color = colors.bg2 },
		})
	end)
end)

front_app:subscribe("mouse.clicked", function()
	sbar.trigger("swap_menus_and_spaces")
end)