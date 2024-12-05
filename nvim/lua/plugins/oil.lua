return {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- Optional for file icons
    opts = {
        -- Oil-specific options
        view_options = {
            show_hidden = true, -- Show hidden files
        },
        keymaps = {
            ["<CR>"] = "actions.select", -- Open file or enter directory
            ["<C-p>"] = "actions.preview", -- Preview file
            ["q"] = "actions.close", -- Close Oil
            ["<leader>e"] = false, -- Disable the default keymap
        },
        float = {
            padding = 2, -- Add padding around floating window
            max_width = 100, -- Max width of the floating window
            max_height = 20, -- Max height of the floating window
        },
    },
    keys = {
        { "<leader>e", ":Oil<CR>", desc = "Open File Manager" },
    },
}
