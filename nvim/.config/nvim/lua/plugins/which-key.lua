return {
  'folke/which-key.nvim',
  config = function()
	local wk = require("which-key")
	wk.setup {
	  ---@type false | "classic" | "modern" | "helix"
	  preset = "helix",
	  delay = 0,
	  spec = {
		{ "<leader>l", group = "LSP" },
		{ "<leader>h", group = "Harpoon" },
		{ "<leader>g", group = "Git" },
	  }
	}
  end
}
