return {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim", },
    config = function()
        require("noice").setup({
            -- Disable everything except hover
            cmdline = { enabled = false },
            messages = { enabled = false },
            popupmenu = { enabled = false },
            notify = { enabled = false },
            lsp = {
                progress = { enabled = false }, -- No LSP progress messages
                hover = {
                    enabled = true,  -- ✅ Enable LSP hover popups
                    silent = false,  -- Show errors if hover fails
                },
                signature = { enabled = false }, -- Disable LSP signature help
                message = { enabled = false }, -- Disable LSP messages
                documentation = { view = "hover" }, -- Ensure docs use hover UI
            },
        })
    end,
}
