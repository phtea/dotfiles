return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" }, -- Required dependency for Telescope
  cmd = "Telescope", -- Load Telescope on demand
  keys = {
    { "<leader>sd", ":Telescope diagnostics<CR>", desc = "Show LSP diagnostics" },
    { "<leader>sh", ":Telescope help_tags<CR>", desc = "Search help documentation" },
    { "<leader>sg", ":Telescope live_grep<CR>", desc = "Search in project (grep)" },
    { "<leader>sf", ":Telescope find_files<CR>", desc = "Find files in current directory" },
    { "<leader>ds", ":Telescope lsp_dynamic_workspace_symbols<CR>", desc = "Find symbols across project" },
	{ "<leader>sr", ":Telescope lsp_references<CR>", desc = "Find Go references" },  -- Added Go references
	{ "<leader>sd", ":Telescope lsp_definitions<CR>", desc = "Find Go definitions" },  -- Find Go definitions
  },
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      defaults = {
        prompt_prefix = " ",
        selection_caret = " ",
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

