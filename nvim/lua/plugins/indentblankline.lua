return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
	config = function()
		local highlight = { "IndentRose", "IndentAmber", "IndentGreen", "IndentCyan", "IndentViolet" }

		local function set_hl()
			-- ibl's own groups (these avoid the "IblScope not found" error)
			vim.api.nvim_set_hl(0, "IblIndent", { fg = "#3b3b4f" })
			vim.api.nvim_set_hl(0, "IblWhitespace", { fg = "#3b3b4f" })
			vim.api.nvim_set_hl(0, "IblScope", { fg = "#ff2d95" })

			-- fg = the dotted guide, bg = the dim band behind it
			vim.api.nvim_set_hl(0, "IndentRose", { fg = "#ff6b9d", bg = "#3a2030" })
			vim.api.nvim_set_hl(0, "IndentAmber", { fg = "#ffb86c", bg = "#3a2f1f" })
			vim.api.nvim_set_hl(0, "IndentGreen", { fg = "#7ee787", bg = "#1f3326" })
			vim.api.nvim_set_hl(0, "IndentCyan", { fg = "#56d4dd", bg = "#1c3338" })
			vim.api.nvim_set_hl(0, "IndentViolet", { fg = "#bd93f9", bg = "#2d2640" })
		end

		set_hl()
		local hooks = require("ibl.hooks")
		hooks.register(hooks.type.HIGHLIGHT_SETUP, set_hl)
		-- ┊
		require("ibl").setup({
			indent = { highlight = highlight, char = "┊" },
			whitespace = { highlight = highlight, remove_blankline_trail = false },
			scope = { enabled = false },
		})
	end,
}
-- return {
-- 	"lukas-reineke/indent-blankline.nvim",
-- 	main = "ibl",
-- 	event = { "BufReadPost", "BufNewFile" },
-- 	config = function()
-- 		local hooks = require("ibl.hooks")
--
-- 		hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
-- 			vim.api.nvim_set_hl(0, "IblIndent", { fg = "#4a4f6a" })
-- 			vim.api.nvim_set_hl(0, "IblScope", { fg = "#82aaff", bold = true })
-- 		end)
--
-- 		require("ibl").setup({
-- 			indent = { char = "▎", tab_char = "▎", highlight = "IblIndent" },
-- 			scope = {
-- 				enabled = true,
-- 				show_start = false,
-- 				show_end = false,
-- 				char = "▎",
-- 				highlight = "IblScope",
-- 			},
-- 			exclude = {
-- 				filetypes = {
-- 					"help",
-- 					"startify",
-- 					"dashboard",
-- 					"packer",
-- 					"neogitstatus",
-- 					"NvimTree",
-- 					"neo-tree",
-- 					"Trouble",
-- 				},
-- 			},
-- 		})
-- 	end,
-- }
