return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gwrite", "Gread", "Glog", "Gblame" },
  keys = {
    { "<leader>gs", "<cmd>Git<cr>", desc = "Git status (fugitive)" },
    { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
    { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git blame" },
    { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git diff split" },
    { "<leader>gl", "<cmd>Git log<cr>", desc = "Git log" },
  },
  init = function()
    vim.cmd("autocmd FileType fugitive setlocal bufhidden=delete")
  end,
}
