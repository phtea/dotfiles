return {
  {
    "tpope/vim-fugitive",
    keys = {
      { "<leader>gc", "<cmd>Git commit<CR>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<CR>", desc = "Git push" },
      { "<leader>gl", "<cmd>Git pull<CR>", desc = "Git pull" },
      { "<leader>gs", "<cmd>Git status<CR>", desc = "Git status" },
      { "<leader>ga", "<cmd>Git add .<CR>", desc = "Git stage all changes" },  -- Stage all changes
      { "<leader>gf", "<cmd>Git add %<CR>", desc = "Git stage current file" },  -- Stage current file
    },
  },
}
