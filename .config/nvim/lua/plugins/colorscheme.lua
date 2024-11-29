return {
    {
        "EdenEast/nightfox.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("nightfox")
            vim.cmd("highlight CursorLineNr guifg=#ff6347")
			vim.api.nvim_set_hl(0, "Visual", { bg = "#6a7f98", fg = "#ffffff" })  -- Adjust the background color for selected text
        end,
    },
}

