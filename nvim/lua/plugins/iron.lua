return {
	"Vigemus/iron.nvim",
	ft = { "python", "sh" },
	cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
	keys = {
		{ "<leader>ir", "<cmd>IronRepl<cr>", desc = "[I]ron [R]un REPL" },
		{ "<leader>is", "<cmd>IronRestart<cr>", desc = "[I]ron Re[s]tart" },
		{
			"<leader>ih",
			function()
				require("iron.core").close_repl("python")
			end,
			desc = "[I]ron [H]ide",
		},
		{
			"<leader>if",
			function()
				require("iron.core").focus_on("python")
			end,
			desc = "[I]ron [F]ocus",
		},
		{
			"<leader>ic",
			function()
				local start_line = vim.fn.search("^# %%", "bcnW")
				if start_line == 0 then
					start_line = 1
				end
				local end_line = vim.fn.search("^# %%", "nW")
				if end_line == 0 then
					end_line = vim.fn.line("$")
				end
				local from = start_line == 1 and 0 or start_line
				local lines = vim.api.nvim_buf_get_lines(0, from, end_line - 1, false)
				require("iron.core").send(nil, lines)
			end,
			desc = "[I]ron send [C]ell",
		},
		{
			"<leader>im",
			mode = "v",
			function()
				-- Exit visual mode to update the '< and '> marks to the current selection
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

				-- Schedule the text extraction to occur after visual mode has exited
				vim.schedule(function()
					local s = vim.fn.getpos("'<")[2]
					local e = vim.fn.getpos("'>")[2]
					local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
					table.insert(lines, 1, "# %% [markdown]")
					require("iron.core").send(nil, lines)
				end)
			end,
			desc = "[I]ron visual send as [M]arkdown",
		},
		{
			"<leader>iv",
			mode = "v",
			function()
				-- Exit visual mode to update the '< and '> marks to the current selection
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)

				-- Schedule the text extraction to occur after visual mode has exited
				vim.schedule(function()
					local s = vim.fn.getpos("'<")[2]
					local e = vim.fn.getpos("'>")[2]
					local lines = vim.api.nvim_buf_get_lines(0, s - 1, e, false)
					table.insert(lines, 1, "# %%")
					require("iron.core").send(nil, lines)
				end)
			end,
			desc = "[I]ron [V]isual Send",
		},
		{
			"<leader>il",
			function()
				local line = vim.api.nvim_get_current_line()
				require("iron.core").send(nil, { "# %%", line })
			end,
			desc = "[I]ron send [L]ine",
		},
		{
			"<leader>iL",
			function()
				require("iron.core").send(nil, { "%logstart -o session.py over" })
			end,
			desc = "[I]ron start [L]og",
		},
	},
	config = function()
		local iron = require("iron.core")
		local view = require("iron.view")

		iron.setup({
			config = {
				scratch_repl = true,
				close_window_on_exit = true,
				repl_open_cmd = view.split.vertical.botright("40%"),
				repl_definition = {
					python = {
						command = function()
							if vim.env.VIRTUAL_ENV then
								return { vim.env.VIRTUAL_ENV .. "/bin/ipython", "--no-autoindent" }
							end
							local local_venv = vim.fn.getcwd() .. "/.venv/bin/ipython"
							if vim.fn.executable(local_venv) == 1 then
								return { local_venv, "--no-autoindent" }
							end
							local global_ipython = vim.fn.expand("~/.datascience-env/bin/ipython")
							if vim.fn.executable(global_ipython) == 1 then
								return { global_ipython, "--no-autoindent" }
							end
							return { "ipython", "--no-autoindent" }
						end,
						format = require("iron.fts.common").bracketed_paste,
					},
				},
			},
			keymaps = {
				send_file = "<leader>ia",
				cr = "<leader>i<cr>",
				interrupt = "<leader>i<space>",
				exit = "<leader>iq",
				clear = "<leader>cl",
			},
			highlight = {
				italic = true,
			},
			ignore_blank_lines = true,
		})
	end,
}
