require("core.options") -- Load general options
require("core.keymaps") -- Load general keymaps
require("core.snippets") -- Custom code snippets

-- Set up the Lazy plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end
vim.opt.rtp:prepend(lazypath)

-- Autocommands for Snacks Picker and Bufferline transparent highlights
vim.api.nvim_create_autocmd("ColorScheme", {
	callback = function()
		-- Snacks Picker column styling
		vim.api.nvim_set_hl(0, "SnacksPickerDir", { fg = "#737aa2", bg = "NONE", italic = true })
		vim.api.nvim_set_hl(0, "SnacksPickerKeymapLhs", { fg = "#ffffff", bold = false })
		vim.api.nvim_set_hl(0, "SnacksPickerKeymapDesc", { fg = "#c0caf5" })
		vim.api.nvim_set_hl(0, "SnacksPickerMode", { fg = "#bb9af7" })
		vim.api.nvim_set_hl(0, "SnacksPickerBorder", { fg = "#565f89" })

		-- Bufferline / Tabline background transparency
		vim.api.nvim_set_hl(0, "TabLine", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "TabLineFill", { bg = "NONE", ctermbg = "NONE" })
		vim.api.nvim_set_hl(0, "TabLineSel", { bg = "NONE", ctermbg = "NONE" })
	end,
})

vim.g.python3_host_prog = vim.fn.expand("~/.datascience-env/bin/python")

-- Load all plugins from lua/plugins (loads jellyfish.nvim first with to priority = 1000)
require("lazy").setup({
	{ import = "plugins" },
})
