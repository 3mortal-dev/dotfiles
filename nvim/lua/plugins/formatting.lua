return {
	"nvimtools/none-ls.nvim",
	dependencies = {
		"nvimtools/none-ls-extras.nvim",
		"jayp0521/mason-null-ls.nvim",
	},
	config = function()
		local null_ls = require("null-ls")
		local formatting = null_ls.builtins.formatting
		local diagnostics = null_ls.builtins.diagnostics

		require("mason-null-ls").setup({
			ensure_installed = {
				"prettier",
				"eslint_d",
				"shfmt",
				"checkmake",
			},
			automatic_installation = true,
		})

		local sources = {
			diagnostics.checkmake,
			formatting.prettier.with({ filetypes = { "html", "json", "yaml", "markdown" } }),
			formatting.stylua,
			formatting.shfmt.with({ args = { "-i", "4" } }),
			formatting.terraform_fmt,
			require("none-ls.formatting.ruff").with({ extra_args = { "--extend-select", "I" } }),
			require("none-ls.formatting.ruff_format").with({
				extra_args = { "--config", "indent-width=2" },
			}),
		}

		-- Set up null-ls without the format-on-save autocommand
		null_ls.setup({
			sources = sources,
		})

		-- Create a manual keymap to format the file (e.g., <leader>fj)
		vim.keymap.set("n", "<leader>fj", function()
			vim.lsp.buf.format({ async = true })
		end, { desc = "[F]ormat current buffer" })
	end,
}
