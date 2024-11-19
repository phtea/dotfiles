-- lua/plugins/treesitter.lua

vim.cmd([[set foldmethod=syntax]])
vim.cmd([[set foldlevel=99]])

return {
  -- Add treesitter plugin
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",  -- Automatically install the parsers
  config = function()
    require'nvim-treesitter.configs'.setup {
      -- Enable all available parsers
      ensure_installed = {"lua", "python", "go"},  -- Or specify a list like {"lua", "python", "javascript"}
    }
  end
}
