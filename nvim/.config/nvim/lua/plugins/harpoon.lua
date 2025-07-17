return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2", -- important for v2
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
	local harpoon = require("harpoon")

	harpoon:setup({
	    settings = {
		save_on_toggle = true,
		sync_on_ui_close = true,
	    },
	})

	-- Keymaps
	vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end, { desc = "Harpoon add file" })
	vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon menu" })

	vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
	vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
	vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
	vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })

	vim.api.nvim_set_hl(0, "HarpoonWindow", { link = "NormalFloat" })
	vim.api.nvim_set_hl(0, "HarpoonBorder", { link = "FloatBorder" })
    end,
}
