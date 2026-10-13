return {
	"pawelborkar/jellyfish.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		local bg_transparent = true

		local apply_custom_highlights = function()
			-- Active line contrasts
			vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2d1947", bold = false })
			vim.api.nvim_set_hl(0, "NeoTreeCursorLine", { bg = "#3b1e5e", bold = true })

			-- Neo-tree elements
			vim.api.nvim_set_hl(0, "NeoTreeDirectoryName", { fg = "#ff5370", bold = true })
			vim.api.nvim_set_hl(0, "NeoTreeDirectoryIcon", { fg = "#ff5370" })
			vim.api.nvim_set_hl(0, "NeoTreeFileName", { fg = "#e0e6fc" })
			vim.api.nvim_set_hl(0, "NeoTreeFileIcon", { fg = "#82aaff" })
			vim.api.nvim_set_hl(0, "NeoTreeModified", { fg = "#ff5370", bold = true })
			vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "NONE" })
			vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "NONE" })
		end

		local set_transparency = function(transparent)
			local groups = {
				"Normal",
				"NormalNC",
				"NormalFloat",
				"FloatBorder",
				"SignColumn",
				"LineNr",
				"FoldColumn",
				"EndOfBuffer",
				"NeoTreeNormal",
				"NeoTreeNormalNC",
				"StatusLine",
				"StatusLineNC",
				"TabLine",
				"TabLineFill",
				"TabLineSel",
			}

			if transparent then
				for _, group in ipairs(groups) do
					vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE" })
				end

				-- Clear lualine middle sections across modes
				local modes = { "normal", "insert", "visual", "replace", "command", "inactive" }
				local sections = { "b", "c", "x", "y" }
				for _, m in ipairs(modes) do
					for _, s in ipairs(sections) do
						local hl_group = "lualine_" .. s .. "_" .. m
						local existing = vim.api.nvim_get_hl(0, { name = hl_group })
						if existing and next(existing) then
							existing.bg = nil
							existing.ctermbg = nil
							vim.api.nvim_set_hl(0, hl_group, existing)
						else
							vim.api.nvim_set_hl(0, hl_group, { bg = "NONE", ctermbg = "NONE" })
						end
					end
				end
			else
				vim.cmd("colorscheme jellyfish")
			end

			apply_custom_highlights()
		end

		-- Initial load (Transparent by default)
		vim.cmd("colorscheme jellyfish")
		set_transparency(true)

		local toggle_transparency = function()
			bg_transparent = not bg_transparent
			set_transparency(bg_transparent)
		end

		vim.keymap.set("n", "<leader>bg", toggle_transparency, {
			noremap = true,
			silent = true,
			desc = "Toggle background transparency",
		})
	end,
}
