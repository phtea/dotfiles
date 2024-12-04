return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency for Telescope
  cmd = "Telescope", -- Load Telescope on demand
  keys = {
    { "<leader>fd", "<cmd>Telescope diagnostics<CR>", desc = "Show LSP diagnostics" },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Search help documentation" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Search in project (grep)" },
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find files in current directory" },
    { "<leader><leader>", "<cmd>Telescope find_files<CR>", desc = "Find files in current directory" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "Search Keymaps" },
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        layout_config = {
          horizontal = { preview_width = 0.55 },
          vertical = { mirror = false },
        },
        sorting_strategy = "ascending",
        mappings = {
          i = {
            ["<C-j>"] = "move_selection_next",
            ["<C-k>"] = "move_selection_previous",
          },
        },
      },
    })
  end,
}

