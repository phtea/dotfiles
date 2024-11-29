return {
  {
    "neovim/nvim-lspconfig",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local capabilities = cmp_nvim_lsp.default_capabilities()

      local lspconfig = require("lspconfig")
      lspconfig.gopls.setup({ capabilities = capabilities })
      lspconfig.pyright.setup({ capabilities = capabilities })
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
        capabilities = capabilities,
      })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
      })

      -- Unmap default LSP keybindings
      local keymaps = { "grn", "grr", "gra", "gri" }
      for _, keymap in ipairs(keymaps) do
        vim.api.nvim_del_keymap("n", keymap)
      end
      vim.api.nvim_del_keymap("x", "gra") -- Unmap visual mode `gra`

      -- Custom key mappings for LSP actions
      vim.api.nvim_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', { noremap = true, silent = true, desc = 'Code actions' })
      vim.api.nvim_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', { noremap = true, silent = true, desc = 'Rename symbol' })
    end,
  },
}
