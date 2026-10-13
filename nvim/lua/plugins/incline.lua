-- ~/.config/nvim/lua/plugins/incline.lua
return {
	"b0o/incline.nvim",
	event = "BufReadPre",
	priority = 1200,
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local devicons = require("nvim-web-devicons")

		require("incline").setup({
			hide = {
				only_win = false, -- show on all windows, even if there's only one
			},
			window = {
				padding = 0,
				margin = { horizontal = 1, vertical = 1 },
				placement = { horizontal = "right", vertical = "top" },
			},
			render = function(props)
				local bufname = vim.api.nvim_buf_get_name(props.buf)
				local filename = vim.fn.fnamemodify(bufname, ":t")
				if filename == "" then
					filename = "[No Name]"
				end

				local ext = vim.fn.fnamemodify(bufname, ":e")
				local icon, icon_color = devicons.get_icon_color(filename, ext, { default = true })

				local modified = vim.bo[props.buf].modified

				return {
					{ " " },
					{ icon, guifg = icon_color },
					{ " " .. filename .. " ", gui = modified and "bold" or "none" },
					modified and { "[+] ", guifg = "#ff9e64" } or "",
				}
			end,
		})
	end,
}
