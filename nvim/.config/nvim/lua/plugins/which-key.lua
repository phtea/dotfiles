return {
  'folke/which-key.nvim',
  config = function()
	local wk = require("which-key")
	wk.setup {
	  ---@type false | "classic" | "modern" | "helix"
	  preset = "helix",
	  spec = {
		{ "<leader>l", group = "LSP", icon = "" },
		{ "<leader>m", group = "Bookmarks", icon = "" },
		{ "<leader>g", group = "Git", icon = "󰊢" },
		{ "<leader>w", proxy = "<c-w>", group = "Windows" },
	  }
	}
  end
}
