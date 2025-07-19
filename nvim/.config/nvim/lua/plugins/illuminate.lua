return {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
	require("illuminate").configure({
	    providers = {
		"regex", -- or add 'treesitter', 'lsp' if you want fallback chain
		"treesitter",
	    },
	    delay = 100,
	    under_cursor = true,
	    large_file_overrides = nil,
	    filetypes_denylist = { "NvimTree", "TelescopePrompt", "harpoon", "oil",  },
	})

	-- Disable highlights in Insert mode
	vim.api.nvim_create_autocmd({ "InsertEnter" }, {
	    callback = function()
		vim.cmd("IlluminatePauseBuf")
	    end,
	})

	-- Enable highlights in Normal mode
	vim.api.nvim_create_autocmd({ "InsertLeave" }, {
	    callback = function()
		vim.cmd("IlluminateResumeBuf")
	    end,
	})
    end,
}
