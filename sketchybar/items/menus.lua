local colors = require("colors")
local settings = require("settings")

local menu_watcher = sbar.add("item", {
	drawing = false,
	updates = false,
})

local max_items = 15
local menu_items = {}

for i = 1, max_items do
	local menu = sbar.add("item", "menu." .. i, {
		drawing = false,
		icon = { drawing = false },
		label = {
			font = {
				style = settings.font.style_map["SemiBold"],
				size = 13.0,
			},
			padding_left = 6,
			padding_right = 6,
			color = colors.white,
		},
		click_script = "$CONFIG_DIR/helpers/menus/bin/menus -s " .. i,
	})
	menu_items[i] = menu
end

local function update_menus()
	sbar.exec("$CONFIG_DIR/helpers/menus/bin/menus -l", function(menus)
		local count = 0
		for line in string.gmatch(menus, "[^\r\n]+") do
			count = count + 1
			if count <= max_items then
				menu_items[count]:set({
					label = { string = line },
					drawing = true,
				})
			end
		end
		for i = count + 1, max_items do
			menu_items[i]:set({ drawing = false })
		end
	end)
end

local function hide_menus()
	for i = 1, max_items do
		menu_items[i]:set({ drawing = false })
	end
end

-- Listen for front app switches to update the menu titles if menus are currently visible
menu_watcher:subscribe("front_app_switched", function()
	sbar.exec("sketchybar --query front_app", function(res)
		-- Only fetch menus if menus are currently drawn
		if menu_items[1]:query().geometry.drawing == "on" then
			update_menus()
		end
	end)
end)

-- Handle the swap event cleanly
menu_watcher:subscribe("swap_menus_and_spaces", function()
	local showing_menus = menu_items[1]:query().geometry.drawing == "on"
	if showing_menus then
		hide_menus()
	else
		update_menus()
	end
end)