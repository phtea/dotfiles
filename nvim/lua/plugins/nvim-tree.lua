return {
  "nvim-tree/nvim-tree.lua",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for file icons
  opts = {
    disable_netrw = true, -- Disables netrw
    hijack_netrw = true, -- Replace netrw with nvim-tree
    view = {
      side = "left",
      width = 30,
    },
    renderer = {
      icons = {
        show = {
          file = true,
          folder = true,
          folder_arrow = true,
          git = true,
        },
      },
    },
  },
  keys = {
    { "<leader>e", ":NvimTreeToggle<CR>", desc = "Toggle File Explorer" },
  },
}
