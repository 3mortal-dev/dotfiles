return {
	-- HACK: docs @ https://github.com/folke/snacks.nvim/blob/main/docs
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			notify = { enabled = false },
			notifier = { enabled = false },
			styles = {
				input = {
					keys = {
						n_esc = { "<C-c>", { "cmp_close", "cancel" }, mode = "n", expr = true },
						i_esc = { "<C-c>", { "cmp_close", "stopinsert" }, mode = "i", expr = true },
					},
				},
			},
			input = {
				enabled = true,
			},
			quickfile = {
				enabled = true,
				exclude = { "latex" },
			},
			picker = {
				enabled = true,
				matchers = {
					frecency = true,
					cwd_bonus = false,
				},
				exclude = {
					".git",
					"node_modules",
					"dist",
					"build",
				},
				formatters = {
					file = {
						filename_first = true,
						filename_only = false,
						icon_width = 2,
					},
				},
				layout = {
					preset = "telescope",
					cycle = false,
				},
				sources = {
					keymaps = {
						-- Disable the preview pane so results use the full width
						layout = {
							preset = "telescope",
							preview = false,
						},
						format = function(item, _)
							local ret = {}

							-- 1. Mode (e.g., 'n')
							local mode = (item.item.mode or "n"):lower()
							table.insert(ret, { string.format("%-2s", mode), "SnacksPickerMode" })

							-- 2. First Column Divider '|'
							table.insert(ret, { "| ", "SnacksPickerBorder" })

							-- 3. Keybinding (LHS) padded to 22 characters
							local key = vim.fn.keytrans(item.item.lhs or "")
							key = key:gsub(" ", "<Space>")
							table.insert(ret, { string.format("%-22s", key), "SnacksPickerKeymapLhs" })

							-- 4. Middle Divider with asterisk '| * '
							table.insert(ret, { "| * ", "SnacksPickerBorder" })

							-- 5. Description / Command
							local desc = item.item.desc or item.item.rhs or ""
							table.insert(ret, { desc, "SnacksPickerKeymapDesc" })

							return ret
						end,
					},
				},
				layouts = {
					select = {
						preview = false,
						layout = {
							backdrop = false,
							width = 0.6,
							min_width = 80,
							height = 0.4,
							min_height = 10,
							box = "vertical",
							border = "rounded",
							title = "{title}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", width = 0.6, height = 0.4, border = "top" },
						},
					},
					telescope = {
						reverse = true, -- Selection starts at the bottom above the prompt
						layout = {
							box = "horizontal",
							backdrop = false,
							width = 0.85,
							height = 0.85,
							border = "none",
							{
								box = "vertical",
								{
									win = "list",
									title = " Results ",
									title_pos = "right",
									border = "rounded",
								},
								{
									win = "input",
									height = 1,
									title = " {title} ",
									title_pos = "right",
									border = "rounded",
								},
							},
							{
								win = "preview",
								title = " {preview:Preview} ",
								title_pos = "right",
								width = 0.55,
								border = "rounded",
							},
						},
					},
					ivy = {
						layout = {
							box = "vertical",
							backdrop = false,
							width = 0,
							height = 0.4,
							position = "bottom",
							border = "top",
							title = " {title} {live} {flags}",
							title_pos = "left",
							{ win = "input", height = 1, border = "bottom" },
							{
								box = "horizontal",
								{ win = "list", border = "none" },
								{ win = "preview", title = "{preview}", width = 0.5, border = "left" },
							},
						},
					},
				},
			},
			image = {
				enabled = true,
				math = { enabled = false },
				doc = {
					inline = true,
					float = false,
					max_width = 50,
					max_height = 30,
					wo = {
						wrap = false,
					},
				},
				convert = {
					notify = true,
					command = "magick",
				},
				img_dirs = {
					"img",
					"images",
					"assets",
					"static",
					"public",
					"media",
					"attachments",
					"Archives/All-Vault-Images/",
					"~/Library",
					"~/Downloads",
				},
			},
			dashboard = {
				enabled = true,
				preset = {
					header = [[
██████╗ ███╗   ███╗ ██████╗ ██████╗ ████████╗ █████╗ ██╗     
╚════██╗████╗ ████║██╔═████╗██╔══██╗╚══██╔══╝██╔══██╗██║     
 █████╔╝██╔████╔██║██║██╔██║██████╔╝   ██║   ███████║██║     
 ╚═══██╗██║╚██╔╝██║████╔╝██║██╔══██╗   ██║   ██╔══██║██║     
██████╔╝██║ ╚═╝ ██║╚██████╔╝██║  ██║   ██║   ██║  ██║███████╗
╚═════╝ ╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚═╝  ╚═╝╚══════╝]],
				},
				sections = {
					{ section = "header" },
					{ section = "keys", gap = 1, padding = 1 },
					{ section = "startup" },
				},
			},
		},
		keys = {
			-- Git / LazyGit
			{
				"<leader>lg",
				function()
					require("snacks").lazygit()
				end,
				desc = "Lazygit",
			},
			{
				"<leader>gl",
				function()
					require("snacks").lazygit.log()
				end,
				desc = "Lazygit Logs",
			},
			{
				"<leader>gbr",
				function()
					require("snacks").picker.git_branches({ layout = "select" })
				end,
				desc = "Pick and Switch Git Branches",
			},

			-- Buffer / File Utils
			{
				"<leader>rN",
				function()
					require("snacks").rename.rename_file()
				end,
				desc = "Fast Rename Current File",
			},
			{
				"<leader>dB",
				function()
					require("snacks").bufdelete()
				end,
				desc = "Delete or Close Buffer (Confirm)",
			},

			-- Search Pickers (Telescope Replacements)
			{
				"<leader>sf",
				function()
					require("snacks").picker.files({
						hidden = true,
						ignored = false,
						exclude = { "node_modules", ".git", ".venv" },
					})
				end,
				desc = "[S]earch [F]iles",
			},
			{
				"<leader>sg",
				function()
					require("snacks").picker.grep({
						hidden = true,
						exclude = { "node_modules", ".git", ".venv" },
					})
				end,
				desc = "[S]earch by [G]rep",
			},
			{
				"<leader>sw",
				function()
					require("snacks").picker.grep_word()
				end,
				desc = "[S]earch current [W]ord",
				mode = { "n", "x" },
			},
			{
				"<leader>sk",
				function()
					require("snacks").picker.keymaps()
				end,
				desc = "[S]earch [K]eymaps",
			},
			{
				"<leader>sh",
				function()
					require("snacks").picker.help()
				end,
				desc = "[S]earch [H]elp",
			},
			{
				"<leader>sd",
				function()
					require("snacks").picker.diagnostics()
				end,
				desc = "[S]earch [D]iagnostics",
			},
			{
				"<leader>s.",
				function()
					require("snacks").picker.resume()
				end,
				desc = "[S]earch [R]esume",
			},
			{
				"<leader>sr",
				function()
					require("snacks").picker.recent()
				end,
				desc = '[S]earch Recent Files ("." for repeat)',
			},
			{
				"<leader><leader>",
				function()
					require("snacks").picker.buffers()
				end,
				desc = "[ ] Find existing buffers",
			},
			{
				"<leader>/",
				function()
					require("snacks").picker.lines({ layout = "select" })
				end,
				desc = "[/] Fuzzily search in current buffer",
			},
			{
				"<leader>s/",
				function()
					require("snacks").picker.grep_buffers()
				end,
				desc = "[S]earch [/] in Open Files",
			},
			{
				"<leader>ss",
				function()
					require("snacks").picker()
				end,
				desc = "[S]earch [S]elect Picker",
			},

			-- Other Utils
			{
				"<leader>th",
				function()
					require("snacks").picker.colorschemes({ layout = "ivy" })
				end,
				desc = "Pick Color Schemes",
			},
			{
				"<leader>vh",
				function()
					require("snacks").picker.help()
				end,
				desc = "Help Pages",
			},

			-- Todo Comments
			{
				"<leader>st",
				function()
					require("snacks").picker.todo_comments({
						layout = "telescope",
						exclude = { "**/todo-comments.lua" },
					})
				end,
				desc = "Search All Todos (Snacks)",
			},
			{
				"<leader>sT",
				function()
					require("snacks").picker.todo_comments({
						layout = "telescope",
						keywords = { "TODO", "FORGETNOT", "FIXME" },
						exclude = { "**/todo-comments.lua" },
					})
				end,
				desc = "Search Mains Todos (Snacks)",
			},
		},
	},
}
