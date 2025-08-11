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
		{ "<leader>m", group = "Marks" },
		{ "<leader>g", group = "Git" },
		{ "<leader>w", proxy = "<c-w>", group = "Windows" },
	  },
	}
	-- vim.cmd [[ set timeoutlen=0 ]] -- fix for now
  end,
}
