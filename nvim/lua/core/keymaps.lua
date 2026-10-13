-- Set leader key
vim.g.mapleader = " "
vim.o.timeoutlen = 500
vim.g.maplocalleader = " "

-- Disable the spacebar key's default behavior in Normal and Visual modes
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true, desc = "Disable space (used as leader)" })

-- For conciseness
local opts = { noremap = true, silent = true }

-- save file
vim.keymap.set("n", "<C-s>", "<cmd> w <CR>", vim.tbl_extend("force", opts, { desc = "Save file" }))

-- save file without auto-formatting
vim.keymap.set(
	"n",
	"<leader>sn",
	"<cmd>noautocmd w <CR>",
	vim.tbl_extend("force", opts, { desc = "Save file without auto-formatting" })
)

-- quit file
vim.keymap.set("n", "<C-q>", "<cmd> q <CR>", vim.tbl_extend("force", opts, { desc = "Quit file" }))

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', vim.tbl_extend("force", opts, { desc = "Delete single character without yanking" }))

-- Vertical scroll and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", vim.tbl_extend("force", opts, { desc = "Scroll down and center cursor" }))
vim.keymap.set("n", "<C-u>", "<C-u>zz", vim.tbl_extend("force", opts, { desc = "Scroll up and center cursor" }))

-- Find and center
vim.keymap.set("n", "n", "nzzzv", vim.tbl_extend("force", opts, { desc = "Next search result and center" }))
vim.keymap.set("n", "N", "Nzzzv", vim.tbl_extend("force", opts, { desc = "Previous search result and center" }))

-- Resize with arrows
vim.keymap.set("n", "<Up>", ":resize -2<CR>", vim.tbl_extend("force", opts, { desc = "Decrease window height" }))
vim.keymap.set("n", "<Down>", ":resize +2<CR>", vim.tbl_extend("force", opts, { desc = "Increase window height" }))
vim.keymap.set(
	"n",
	"<Left>",
	":vertical resize -2<CR>",
	vim.tbl_extend("force", opts, { desc = "Decrease window width" })
)
vim.keymap.set(
	"n",
	"<Right>",
	":vertical resize +2<CR>",
	vim.tbl_extend("force", opts, { desc = "Increase window width" })
)

-- Buffers
vim.keymap.set("n", "<Tab>", ":bnext<CR>", vim.tbl_extend("force", opts, { desc = "Go to next buffer" }))
vim.keymap.set("n", "<S-Tab>", ":bprevious<CR>", vim.tbl_extend("force", opts, { desc = "Go to previous buffer" }))
vim.keymap.set("n", "<leader>bd", function()
	local buf = vim.api.nvim_get_current_buf()
	vim.cmd("enew")
	pcall(vim.api.nvim_buf_delete, buf, { force = true })
end, vim.tbl_extend("force", opts, { desc = "Close current buffer, keep window" }))
vim.keymap.set("n", "<leader>bo", "<cmd> enew <CR>", vim.tbl_extend("force", opts, { desc = "Create new buffer" })) -- new buffer

-- Window management
vim.keymap.set("n", "<leader>v", "<C-w>v", vim.tbl_extend("force", opts, { desc = "Split window vertically" })) -- split window vertically
vim.keymap.set("n", "<leader>h", "<C-w>s", vim.tbl_extend("force", opts, { desc = "Split window horizontally" })) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", vim.tbl_extend("force", opts, { desc = "Make split windows equal size" })) -- make split windows equal width & height
vim.keymap.set("n", "<leader>xs", ":close<CR>", vim.tbl_extend("force", opts, { desc = "Close current split window" })) -- close current split window

-- Navigate between splits
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", vim.tbl_extend("force", opts, { desc = "Move focus to upper split" }))
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", vim.tbl_extend("force", opts, { desc = "Move focus to lower split" }))
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", vim.tbl_extend("force", opts, { desc = "Move focus to left split" }))
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", vim.tbl_extend("force", opts, { desc = "Move focus to right split" }))

-- Tabs
vim.keymap.set("n", "<leader>to", ":tabnew<CR>", vim.tbl_extend("force", opts, { desc = "Open new tab" })) -- open new tab
vim.keymap.set("n", "<leader>td", ":tabclose<CR>", vim.tbl_extend("force", opts, { desc = "Close current tab" })) -- close current tab
vim.keymap.set("n", "<leader>tn", ":tabn<CR>", vim.tbl_extend("force", opts, { desc = "Go to next tab" })) --  go to next tab
vim.keymap.set("n", "<leader>tp", ":tabp<CR>", vim.tbl_extend("force", opts, { desc = "Go to previous tab" })) --  go to previous tab

-- Stay in indent mode
vim.keymap.set("v", "<", "<gv", vim.tbl_extend("force", opts, { desc = "Indent left and reselect" }))
vim.keymap.set("v", ">", ">gv", vim.tbl_extend("force", opts, { desc = "Indent right and reselect" }))

-- Keep last yanked when pasting
vim.keymap.set("v", "p", '"_dP', vim.tbl_extend("force", opts, { desc = "Paste without overwriting register" }))

-- In visual mode: select lines, then press shift+j to move down, shift+k to move up
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Go to previous diagnostic message" })

vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Go to next diagnostic message" })

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>qd", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- ======================= IRON =======================
-- Send selected lines in Visual mode to Iron REPL and return to Normal mode
vim.keymap.set("v", "<S-CR>", function()
	require("iron.core").visual_send()
end, { desc = "Run selected block in Interactive REPL" })

-- Terminal fallback if your terminal doesn't send Shift+Enter distinctly:
vim.keymap.set("v", "<leader><CR>", function()
	require("iron.core").visual_send()
end, { desc = "Run selected block in Interactive REPL" })

-- Export the current IPython REPL session to an .ipynb located next to the current file
vim.keymap.set("n", "<leader>io", function()
	local session_input = vim.fn.input("Session log (.py) path: ", "~/", "file")
	if session_input == "" then
		return
	end
	local session_path = vim.fn.fnamemodify(vim.fn.expand(session_input), ":p")

	if vim.fn.filereadable(session_path) == 0 then
		vim.notify("File not found: " .. session_path, vim.log.levels.ERROR)
		return
	end

	local out_input = vim.fn.input("Export notebook to: ", "~/", "file")
	if out_input == "" then
		return
	end
	local out_path = vim.fn.fnamemodify(vim.fn.expand(out_input), ":p")

	-- If they gave a directory (trailing slash, or it already exists as one),
	-- derive a filename from the session log instead of failing later.
	if out_path:sub(-1) == "/" or vim.fn.isdirectory(out_path) == 1 then
		local base = vim.fn.fnamemodify(session_path, ":t:r")
		out_path = out_path .. base .. ".ipynb"
	end

	-- Make sure it actually ends in .ipynb regardless of what was typed.
	if not out_path:match("%.ipynb$") then
		out_path = out_path .. ".ipynb"
	end

	local exec_dir = vim.fn.fnamemodify(session_path, ":h")

	local function find_jupytext()
		if vim.env.VIRTUAL_ENV then
			return vim.env.VIRTUAL_ENV .. "/bin/jupytext"
		end
		local local_venv = vim.fn.getcwd() .. "/.venv/bin/jupytext"
		if vim.fn.executable(local_venv) == 1 then
			return local_venv
		end
		local global_env = vim.fn.expand("~/.datascience-env/bin/jupytext")
		if vim.fn.executable(global_env) == 1 then
			return global_env
		end
		return "jupytext"
	end

	local cmd = {
		find_jupytext(),
		"--to",
		"notebook",
		"--execute",
		"--output",
		out_path,
		session_path,
	}

	vim.notify("Exporting notebook...", vim.log.levels.INFO)

	vim.fn.jobstart(cmd, {
		cwd = exec_dir,
		on_exit = function(_, code)
			if code == 0 then
				vim.notify("Notebook saved to: " .. out_path, vim.log.levels.INFO)
			else
				vim.notify("jupytext export failed (exit " .. code .. "). Check :messages.", vim.log.levels.ERROR)
			end
		end,
		on_stderr = function(_, data)
			for _, line in ipairs(data) do
				if line ~= "" then
					vim.notify(line, vim.log.levels.WARN)
				end
			end
		end,
	})
end, { desc = "[I]ron [O]utput session to .ipynb" })
