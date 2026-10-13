return {
	"akinsho/bufferline.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local p = {
			magenta = "#f72585",
			cyan = "#00f5d4",
			fg = "#c0caf5",
			gray = "#565f89",
			active = "#1a1b26",
		}

		require("bufferline").setup({
			options = {
				mode = "buffers",
				themable = true,
				numbers = "none",
				close_command = function(bufnr)
					require("snacks").bufdelete(bufnr)
				end,
				buffer_close_icon = "󰅖",
				close_icon = "",
				modified_icon = "●",
				left_trunc_marker = "",
				right_trunc_marker = "",
				max_name_length = 22,
				tab_size = 18,
				diagnostics = false,
				color_icons = true,
				show_buffer_icons = true,
				show_buffer_close_icons = false, -- cleaner, less clutter
				show_close_icon = false,
				show_tab_indicators = false,
				separator_style = "thin", -- or 'slant'
				always_show_bufferline = true,
				indicator = {
					icon = "▎",
					style = "icon",
				},
				custom_filter = function(buf_number)
					-- Do not show terminal buffers in bufferline
					if vim.bo[buf_number].buftype == "terminal" then
						return false
					end
					return true
				end,
			},
			highlights = {
				-- Base empty background across the top bar
				fill = {
					bg = "NONE",
				},
				background = {
					fg = p.gray,
					bg = "NONE",
				},
				-- Inactive buffers
				buffer_visible = {
					fg = p.gray,
					bg = "NONE",
				},
				-- Active buffer (vibrant pill that stands out)
				buffer_selected = {
					fg = "#ffffff",
					bg = "NONE",
					bold = true,
					italic = false,
				},
				-- Indicator bar on the active tab
				indicator_selected = {
					fg = p.magenta,
					bg = "NONE",
				},
				-- Separators
				separator = {
					fg = "#24283b",
					bg = "NONE",
				},
				separator_visible = {
					fg = "#24283b",
					bg = "NONE",
				},
				separator_selected = {
					fg = "#24283b",
					bg = "NONE",
				},
				-- Modified icons
				modified = {
					fg = p.cyan,
					bg = "NONE",
				},
				modified_selected = {
					fg = p.cyan,
					bg = "NONE",
				},
				modified_visible = {
					fg = p.cyan,
					bg = "NONE",
				},
			},
		})
	end,
}
