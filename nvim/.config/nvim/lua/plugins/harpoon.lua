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
	vim.keymap.set("n", "<leader>ma", function() harpoon:list():add() end, { desc = "Marks: Add mark" })
	vim.keymap.set("n", "<leader>mm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
	  { desc = "Marks: Marks menu" })

	local wk = require("which-key")
	wk.add({
	  { "<leader>1", function() harpoon:list():select(1) end, desc = "Mark 1", icon = "" },
	  { "<leader>2", function() harpoon:list():select(2) end, desc = "Mark 2", icon = "" },
	  { "<leader>3", function() harpoon:list():select(3) end, desc = "Mark 3", icon = "" },
	  { "<leader>4", function() harpoon:list():select(4) end, desc = "Mark 4", icon = "" },
	})
  end,
}
