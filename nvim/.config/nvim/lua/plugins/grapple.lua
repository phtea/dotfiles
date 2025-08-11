return {
  "cbochs/grapple.nvim",
  opts = {
	scope = "git", -- also try out "git_branch"
	icons = false, -- setting to "true" requires "nvim-web-devicons"
	status = false,
  },
  keys = {
	{ "<leader>ma", "<cmd>Grapple toggle<cr>", desc = "Tag a file" },
	{ "<leader>mm", "<cmd>Grapple toggle_tags<cr>", desc = "Toggle tags menu" },

	{ "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Select first tag" },
	{ "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Select second tag" },
	{ "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Select third tag" },
	{ "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Select fourth tag" },

	{ "<leader>mn", "<cmd>Grapple cycle_tags next<cr>", desc = "Go to next tag" },
	{ "<leader>mp", "<cmd>Grapple cycle_tags prev<cr>", desc = "Go to previous tag" },
  },
}
