return {
	"folke/flash.nvim",
	event = "VeryLazy",
	---@type Flash.Config
	opts = {
		modes = {
			search = {
				enabled = true,
			},
			char = {
				jump_labels = true,
			},
		},
	},
	init = function()
		local set_flash_hl = function()
			-- The jump character label:
			vim.api.nvim_set_hl(0, "FlashLabel", {
				fg = "#ffffff",
				bg = "#ff007f",
				bold = true,
			})
			-- The matched text / background box:
			vim.api.nvim_set_hl(0, "FlashMatch", {
				fg = "#ffffff",
				bg = "#3b4261", -- dark slate/blue or whatever color you prefer
				bold = false,
			})
		end

		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = set_flash_hl,
		})
		set_flash_hl()
	end,
	-- stylua: ignore
	keys = {
		{ "<leader>fl", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
		-- { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
		{ "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
		-- { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
		{ "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
	},
}
