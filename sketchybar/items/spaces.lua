local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

local workspace_letters = {"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R",
                           "S", "T", "U", "V", "W", "X", "Y", "Z", "1", "2", "3", "4", "5", "6", "7", "8", "9"}

local spaces = {}
local brackets = {}
local paddings = {}
local showing_spaces = true
local fullscreen_workspaces = {}

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_fullscreen_toggle")

-- 1. Pre-register items
for _, sid in ipairs(workspace_letters) do
    local space = sbar.add("item", "space." .. sid, {
        drawing = false,
        icon = {
            font = {
                family = "SF Pro Rounded",
                style = "Bold",
                size = 14.0
            },
            string = sid,
            padding_left = 12,
            padding_right = 6,
            color = colors.white,
            highlight_color = colors.yellow
        },
        label = {
            padding_right = 20,
            color = colors.white,
            highlight_color = colors.sora.primary,
            font = "sketchybar-app-font:Regular:16.0",
            y_offset = -1
        },
        padding_right = 1,
        padding_left = 1,
        background = {
            color = colors.bar.bg,
            border_width = 2,
            height = 28,
            border_color = colors.black
        },
        popup = {
            background = {
                border_width = 5,
                border_color = colors.black
            }
        }
    })

    local bracket = sbar.add("bracket", {space.name}, {
        drawing = false,
        background = {
            color = colors.transparent,
            border_color = colors.bg2,
            height = 30,
            border_width = 2
        }
    })

    local padding = sbar.add("item", "space.padding." .. sid, {
        drawing = false,
        width = settings.group_paddings
    })

    space:subscribe("mouse.clicked", function()
        sbar.exec("/opt/homebrew/bin/aerospace workspace " .. sid)
    end)

    spaces[sid] = space
    brackets[sid] = bracket
    paddings[sid] = padding
end

-- 2. Synchronize workspace elements
local function sync_workspaces(focused_ws)
    if not showing_spaces then
        return
    end

    local cmd = [[
		export PATH="/opt/homebrew/bin:$PATH"
		CURRENT=$(aerospace list-workspaces --focused)
		WINDOWS=$(aerospace list-windows --all --format '%{workspace} %{app-name}')
		echo "---FOCUSED---"
		echo "${CURRENT}"
		echo "---WINDOWS---"
		echo "${WINDOWS}"
	]]

    sbar.exec(cmd, function(output)
        if not showing_spaces then
            return
        end

        local current_section = ""
        local authoritative_focused = focused_ws or ""
        local workspace_apps = {}

        for line in string.gmatch(output, "[^\r\n]+") do
            if line == "---FOCUSED---" then
                current_section = "focused"
            elseif line == "---WINDOWS---" then
                current_section = "windows"
            elseif current_section == "focused" and authoritative_focused == "" then
                authoritative_focused = string.gsub(line, "%s+", "")
            elseif current_section == "windows" then
                local ws, app = string.match(line, "^(%S+)%s*(.*)$")
                if ws then
                    if not workspace_apps[ws] then
                        workspace_apps[ws] = {}
                    end
                    if app and app ~= "" then
                        table.insert(workspace_apps[ws], app)
                    end
                end
            end
        end

        if authoritative_focused ~= "" and not workspace_apps[authoritative_focused] then
            workspace_apps[authoritative_focused] = {}
        end

        for sid, space in pairs(spaces) do
            local is_active = (workspace_apps[sid] ~= nil)
            local is_focused = (sid == authoritative_focused)
            local is_ws_fullscreen = (fullscreen_workspaces[sid] == true)

            -- If the workspace is empty or has been closed, clean up state
            if not is_active then
                space:set({
                    drawing = false
                })
                brackets[sid]:set({
                    drawing = false
                })
                paddings[sid]:set({
                    drawing = false
                })
                fullscreen_workspaces[sid] = nil
            else
                local icon_line = ""
                local apps = workspace_apps[sid]

                local label_font = "sketchybar-app-font:Regular:16.0"

                if #apps == 0 then
                    icon_line = "—"
                    label_font = "SF Pro Rounded:Bold:13.0"
                else
                    for _, app in ipairs(apps) do
                        local lookup = app_icons[app]
                        local icon = ((lookup == nil) and app_icons["default"] or lookup)
                        icon_line = icon_line .. " " .. icon
                    end
                end

                -- Border highlights
                local border_col = colors.bar.bg
                local bracket_col = colors.bg2

                if is_focused then
                    if is_ws_fullscreen then
                        border_col = colors.sora.gold or colors.yellow
                        bracket_col = colors.sora.rose or colors.red
                    else
                        border_col = colors.highlight
                        bracket_col = colors.grey
                    end
                else
                    if is_ws_fullscreen then
                        border_col = colors.sora.gold or colors.yellow
                        bracket_col = colors.bg2
                    end
                end

                space:set({
                    drawing = true,
                    label = {
                        string = icon_line,
                        highlight = is_focused,
                        font = label_font
                    },
                    icon = {
                        highlight = is_focused
                    },
                    background = {
                        border_color = border_col
                    }
                })
                brackets[sid]:set({
                    drawing = true,
                    background = {
                        border_color = bracket_col
                    }
                })
                paddings[sid]:set({
                    drawing = true
                })
            end
        end
    end)
end

local function hide_all_spaces()
    for sid, space in pairs(spaces) do
        space:set({
            drawing = false
        })
        brackets[sid]:set({
            drawing = false
        })
        paddings[sid]:set({
            drawing = false
        })
    end
end

-- 3. Observers & Listeners
local space_observer = sbar.add("item", {
    drawing = false,
    updates = true
})

space_observer:subscribe("aerospace_workspace_change", function(env)
    sync_workspaces(env.FOCUSED_WORKSPACE)
end)

space_observer:subscribe("aerospace_fullscreen_toggle", function(_)
    sbar.exec("/opt/homebrew/bin/aerospace list-workspaces --focused", function(focused)
        local cur = string.gsub(focused, "%s+", "")
        if cur ~= "" then
            fullscreen_workspaces[cur] = not fullscreen_workspaces[cur]
            sync_workspaces(cur)
        end
    end)
end)

space_observer:subscribe({"space_windows_change", "front_app_switched", "forced"}, function(_)
    sync_workspaces()
end)

-- 4. Spaces Toggle Indicator
local spaces_indicator = sbar.add("item", {
    padding_left = -3,
    padding_right = 0,
    icon = {
        padding_left = 8,
        padding_right = 9,
        color = colors.grey,
        string = icons.switch.on
    },
    label = {
        width = 0,
        padding_left = 0,
        padding_right = 8,
        string = "Spaces",
        color = colors.bg1
    },
    background = {
        color = colors.with_alpha(colors.grey, 0.0),
        border_color = colors.with_alpha(colors.bg1, 0.0)
    }
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(_)
    showing_spaces = not showing_spaces
    spaces_indicator:set({
        icon = showing_spaces and icons.switch.on or icons.switch.off
    })

    if showing_spaces then
        sync_workspaces()
    else
        hide_all_spaces()
    end
end)

spaces_indicator:subscribe("mouse.entered", function(_)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = {
                    alpha = 1.0
                },
                border_color = {
                    alpha = 1.0
                }
            },
            icon = {
                color = colors.bg1
            },
            label = {
                width = "dynamic"
            }
        })
    end)
end)

spaces_indicator:subscribe("mouse.exited", function(_)
    sbar.animate("tanh", 30, function()
        spaces_indicator:set({
            background = {
                color = {
                    alpha = 0.0
                },
                border_color = {
                    alpha = 0.0
                }
            },
            icon = {
                color = colors.grey
            },
            label = {
                width = 0
            }
        })
    end)
end)

spaces_indicator:subscribe("mouse.clicked", function(_)
    sbar.trigger("swap_menus_and_spaces")
end)

sbar.delay(0.1, function()
    sync_workspaces()
end)
