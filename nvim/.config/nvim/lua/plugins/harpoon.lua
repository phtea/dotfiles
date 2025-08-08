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
	vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end, { desc = "Harpoon add" })
	vim.keymap.set("n", "<leader>mm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
	  { desc = "Harpoon menu" })

	vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end, { desc = "Harpoon 1" })
	vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end, { desc = "Harpoon 2" })
	vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end, { desc = "Harpoon 3" })
	vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end, { desc = "Harpoon 4" })
  end,
}
