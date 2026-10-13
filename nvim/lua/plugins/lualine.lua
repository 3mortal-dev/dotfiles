return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local p = {
			bg = "NONE",
			fg = "#c0caf5",
			cyan = "#00f5d4",
			magenta = "#f72585",
			orange = "#ff9f1c",
			sky = "#4cc9f0",
			red = "#e63946",
			gray = "#7b88a1",
			dark = "#0f111a",
		}

		-- Clean theme: 'a' and 'z' have solid vibrant backgrounds,
		-- everything else sits directly on the transparent background.
		local custom_theme = {
			normal = {
				a = { fg = p.dark, bg = p.magenta, gui = "bold" },
				b = { fg = p.sky, bg = "NONE" },
				c = { fg = p.fg, bg = "NONE" },
				x = { fg = p.fg, bg = "NONE" },
				y = { fg = p.cyan, bg = "NONE", gui = "bold" },
				z = { fg = p.dark, bg = p.magenta, gui = "bold" },
			},
			insert = {
				a = { fg = p.dark, bg = p.cyan, gui = "bold" },
				b = { fg = p.cyan, bg = "NONE" },
				c = { fg = p.fg, bg = "NONE" },
				x = { fg = p.fg, bg = "NONE" },
				y = { fg = p.cyan, bg = "NONE", gui = "bold" },
				z = { fg = p.dark, bg = p.cyan, gui = "bold" },
			},
			visual = {
				a = { fg = p.dark, bg = p.orange, gui = "bold" },
				b = { fg = p.orange, bg = "NONE" },
				c = { fg = p.fg, bg = "NONE" },
				x = { fg = p.fg, bg = "NONE" },
				y = { fg = p.orange, bg = "NONE", gui = "bold" },
				z = { fg = p.dark, bg = p.orange, gui = "bold" },
			},
			command = {
				a = { fg = p.dark, bg = p.sky, gui = "bold" },
				b = { fg = p.sky, bg = "NONE" },
				c = { fg = p.fg, bg = "NONE" },
				x = { fg = p.fg, bg = "NONE" },
				y = { fg = p.sky, bg = "NONE", gui = "bold" },
				z = { fg = p.dark, bg = p.sky, gui = "bold" },
			},
			replace = {
				a = { fg = p.dark, bg = p.red, gui = "bold" },
				b = { fg = p.red, bg = "NONE" },
				c = { fg = p.fg, bg = "NONE" },
				x = { fg = p.fg, bg = "NONE" },
				y = { fg = p.red, bg = "NONE", gui = "bold" },
				z = { fg = p.dark, bg = p.red, gui = "bold" },
			},
			inactive = {
				a = { fg = p.gray, bg = "NONE" },
				b = { fg = p.gray, bg = "NONE" },
				c = { fg = p.gray, bg = "NONE" },
				x = { fg = p.gray, bg = "NONE" },
				y = { fg = p.gray, bg = "NONE" },
				z = { fg = p.gray, bg = "NONE" },
			},
		}

		local hide_in_width = function()
			return vim.fn.winwidth(0) > 100
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = custom_theme,
				-- Global separators off so transparent sections stay clean
				section_separators = "",
				component_separators = { left = "", right = "" },
				disabled_filetypes = { "alpha", "neo-tree" },
				always_divide_middle = true,
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = function(str)
							return " " .. str
						end,
						-- Slant outward into the transparent bar
						separator = { right = "" },
					},
				},
				lualine_b = {
					{ "branch", icon = "", color = { fg = p.sky, gui = "bold" } },
				},
				lualine_c = {
					{ "filename", file_status = true, path = 0, color = { fg = p.fg, gui = "bold" } },
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
						colored = true,
						diagnostics_color = {
							error = { fg = p.red },
							warn = { fg = p.orange },
							info = { fg = p.sky },
							hint = { fg = p.cyan },
						},
						cond = hide_in_width,
					},
					{
						"diff",
						colored = true,
						diff_color = {
							added = { fg = p.cyan },
							modified = { fg = p.orange },
							removed = { fg = p.red },
						},
						symbols = { added = " ", modified = " ", removed = " " },
						cond = hide_in_width,
					},
					{ "encoding", cond = hide_in_width, color = { fg = p.gray } },
					{ "filetype", cond = hide_in_width, colored = true },
				},
				lualine_y = {
					{ "location", color = { fg = p.cyan, gui = "bold" } },
				},
				lualine_z = {
					{
						"progress",
						-- Slant inward from the transparent bar into the solid right cap
						separator = { left = "" },
					},
				},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { { "filename", path = 1 } },
				lualine_x = { { "location", padding = 0 } },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			extensions = { "fugitive" },
		})
	end,
}
