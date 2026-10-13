return {
	"vimichael/floatingtodo.nvim",
	cmd = "Td",
	keys = {
		{
			"<leader>tj",
			"<cmd>Td<cr>",
			desc = "Toggle Floating Todo",
		},
	},
	opts = {
		target_file = "~/Obsidian Notes/todo.md",
		border = "rounded",
		width = 0.8,
		height = 0.5,
		position = "center",
	},
	config = function(_, opts)
		require("floatingtodo").setup(opts)

		vim.api.nvim_create_autocmd("BufEnter", {
			callback = function()
				local win_config = vim.api.nvim_win_get_config(0)
				-- Check if the current window is a floating window
				if win_config.relative ~= "" then
					vim.keymap.set("n", "<Tab>", "<Nop>", { buffer = true })
					vim.keymap.set("n", "<S-Tab>", "<Nop>", { buffer = true })
				end
			end,
		})
		-- Auto-save todo.md when editing or closing the window
		vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "BufLeave", "WinLeave" }, {
			pattern = "*/Obsidian Notes/todo.md",
			callback = function()
				vim.cmd("silent! update")
			end,
		})
	end,
}
