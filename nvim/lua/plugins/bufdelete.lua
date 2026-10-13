return {
	"famiu/bufdelete.nvim",
	config = function()
		local function bdelete_or_find()
			-- Count valid, listed normal file buffers
			local bufs = vim.tbl_filter(function(b)
				return vim.api.nvim_buf_is_valid(b) and vim.bo[b].buflisted and vim.bo[b].buftype == ""
			end, vim.api.nvim_list_bufs())

			-- Delete the current buffer cleanly without closing the window
			require("bufdelete").bufdelete(0, false)

			-- If that was the last file buffer, launch the file finder immediately
			if #bufs <= 1 then
				-- Using Telescope:
				-- require("telescope.builtin").find_files()
				-- Or if you prefer Snacks:
				Snacks.picker.recent()
			end
		end

		vim.keymap.set("n", "<leader>bd", bdelete_or_find, { desc = "[B]uffer [D]elete (Find if last)" })
	end,
}
