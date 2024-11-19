-- treesitter.lua

return {
  "nvim-treesitter/nvim-treesitter",
  run = ":TSUpdate",
  config = function()
    require'nvim-treesitter.configs'.setup {
      ensure_installed = { "lua", "python", "go" }, -- Specify the parsers you want
      highlight = {
        enable = true,                              -- Enable Treesitter-based highlighting
        additional_vim_regex_highlighting = false,  -- Disable legacy syntax highlighting
      },
    }
  end
}

