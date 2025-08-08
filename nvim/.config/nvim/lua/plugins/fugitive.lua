return {
  "tpope/vim-fugitive",
  cmd = { "Git", "G", "Gdiffsplit", "Gvdiffsplit", "Gedit", "Gwrite", "Gread", "Glog", "Gblame" },
  keys = {
    { "<leader>gs", "<cmd>Git<cr>", desc = "Git: Status Fugitive" },
    { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git: Commit" },
    { "<leader>gb", "<cmd>Git blame<cr>", desc = "Git: Blame" },
    { "<leader>gd", "<cmd>Gvdiffsplit<cr>", desc = "Git: Diff split" },
    { "<leader>gl", "<cmd>Git log<cr>", desc = "Git: Log" },
  },
  init = function()
    vim.cmd("autocmd FileType fugitive setlocal bufhidden=delete")
  end,
}
