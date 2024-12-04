return {
    "nvim-lualine/lualine.nvim",
	enabled = false,
    dependencies = { "tpope/vim-fugitive" },
    config = function()
        require("lualine").setup({
            options = {
                theme = "auto", -- Automatically detect the colorscheme
                component_separators = "|",
                section_separators = "",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {
                    { "filename", path = 1 }  -- Display relative path
                },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            extensions = { "fugitive" }, -- Adds Fugitive integration for Git status
        })
		vim.opt.showmode = false
    end,
}

