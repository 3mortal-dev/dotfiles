return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")
		local pylint = lint.linters.pylint

		-- use pylint from the active environment instead of Mason's
		pylint.cmd = function()
			local candidates = {
				(vim.env.VIRTUAL_ENV or "") .. "/bin/pylint",
				(vim.env.CONDA_PREFIX or "") .. "/bin/pylint",
				vim.fn.getcwd() .. "/.venv/bin/pylint",
				vim.fn.getcwd() .. "/venv/bin/pylint",
				vim.fn.expand("~/.datascience-env/bin/pylint"),
			}
			for _, path in ipairs(candidates) do
				if vim.fn.executable(path) == 1 then
					return path
				end
			end
			return "pylint"
		end

		pylint.args = vim.list_extend(vim.deepcopy(pylint.args or {}), {
			"--indent-string=  ",
			"--disable=W0113",
		})

		local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

		lint.linters_by_ft = {
			python = { "pylint" },
		}

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lint_augroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>li", function()
			lint.try_lint()
		end, { desc = "Trigger linting for current file" })
	end,
}
