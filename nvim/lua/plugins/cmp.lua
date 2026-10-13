return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet Engine (Required for VS Code-like snippet expansion)
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
				-- Contains thousands of pre-made VS Code snippets for Python, HTML, etc.
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
		"saadparwaiz1/cmp_luasnip",

		-- Completion Sources
		"hrsh7th/cmp-nvim-lsp", -- Gets functions/methods from Pyright/LSP
		"hrsh7th/cmp-path", -- Gets file and directory names (for import paths)
		"hrsh7th/cmp-buffer", -- Gets words from your current file

		-- VS Code-like icons (adds the little cubes, wrenches, and V icons)
		"onsails/lspkind.nvim",
	},
	config = function()
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		local lspkind = require("lspkind")

		luasnip.config.setup({})

		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert" },

			-- VS Code style icons in the completion menu
			formatting = {
				format = lspkind.cmp_format({
					mode = "symbol_text", -- show symbol and text
					maxwidth = 50, -- prevent menu from getting too wide
					ellipsis_char = "...",
				}),
			},

			-- Keybindings for navigating the menu
			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(), -- Next item
				["<C-p>"] = cmp.mapping.select_prev_item(), -- Previous item
				["<C-b>"] = cmp.mapping.scroll_docs(-4), -- Scroll docs up
				["<C-f>"] = cmp.mapping.scroll_docs(4), -- Scroll docs down
				["<C-y>"] = cmp.mapping.confirm({ select = true }), -- Accept suggestion
				["<CR>"] = cmp.mapping.confirm({ select = true }), -- Enter key also confirms
				["<C-Space>"] = cmp.mapping.complete({}), -- Manually trigger completion

				-- Navigate through snippet placeholders (like hitting Tab in VS Code)
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),
			}),

			-- The order here dictates the priority in the popup menu
			sources = {
				{ name = "nvim_lsp" }, -- Highest priority: Methods, variables, functions
				{ name = "luasnip" }, -- Snippets
				{ name = "path" }, -- File names and paths
				-- { name = "buffer", keyword_length = 3 }, -- Words in current file (only after 3 letters)
			},
		})
	end,
}
