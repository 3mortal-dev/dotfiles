-- Standalone plugins with less than 10 lines of config go here
return {
	{
		-- Tmux & split window navigation
		"christoomey/vim-tmux-navigator",
	},
	{
		-- Detect tabstop and shiftwidth automatically
		"tpope/vim-sleuth",
	},
	{
		-- Powerful Git integration for Vim
		"tpope/vim-fugitive",
	},
	{
		-- GitHub integration for vim-fugitive
		"tpope/vim-rhubarb",
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {
			preset = "classic",
			win = {
				-- floating panel on the right edge
				col = math.huge, -- stick to the right side
				row = 1, -- near the top; use math.huge for bottom-right
				width = { min = 35, max = 50 }, -- narrow panel instead of full width
				height = { min = 4, max = 0.8 }, -- up to 80% of the screen height
				border = "rounded",
				padding = { 1, 2 },
				title = true,
				title_pos = "center",
				no_overlap = false, -- allow it to sit over the text if needed
			},
			layout = {
				width = { min = 20 },
				spacing = 3,
			},
		},
	},
	{
		-- Autoclose parentheses, brackets, quotes, etc.
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = true,
		opts = {},
	},
	{
		-- High-performance color highlighter
		"norcalli/nvim-colorizer.lua",
		config = function()
			require("colorizer").setup()
		end,
	},
	{
		"okuuva/auto-save.nvim",
		version = "^1.0.0",
		cmd = "ASToggle",
		event = { "InsertLeave", "TextChanged" },
		opts = {
			debounce_delay = 1000, -- ms to wait after the last change before saving
		},
	},
	{
		"karb94/neoscroll.nvim",
		event = "VeryLazy",
		opts = {
			duration_multiplier = 0.6, -- lower = faster
		},
	},
}
