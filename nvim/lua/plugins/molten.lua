return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  build = ":UpdateRemotePlugins",
  ft = { "python", "ipynb" },
  init = function()
    vim.g.molten_auto_open_output = false
    vim.g.molten_output_win_max_height = 12
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = true
  end,
  keys = {
    { "<leader>mi", ":MoltenInit<CR>", desc = "[M]olten [I]nit Kernel" },
    { "<leader>me", ":MoltenEvaluateOperator<CR>", desc = "[M]olten [E]valuate Operator" },
    { "<leader>mE", ":MoltenEvaluateLine<CR>", desc = "[M]olten [E]valuate Line" },
    { "<leader>mr", ":MoltenReevaluateCell<CR>", desc = "[M]olten [R]eevaluate Cell" },
    { "<leader>mx", ":MoltenInterrupt<CR>", desc = "[M]olten [X] Interrupt" },
    { "]c", ":MoltenNext<CR>", desc = "Next Molten Cell" },
    { "[c", ":MoltenPrev<CR>", desc = "Previous Molten Cell" },
    { "<leader>o", ":MoltenShowOutput<CR>", desc = "Show Cell Output" },
    { "<leader>oh", ":MoltenHideOutput<CR>", desc = "Hide Cell Output" },
  },
}
