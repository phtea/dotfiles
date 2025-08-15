return {
  "cbochs/grapple.nvim",
  opts = {
	scope = "git_branch",
	icons = false, -- setting to "true" requires "nvim-web-devicons"
	status = false,
  },
  keys = {
	{ "<leader>ma", "<cmd>Grapple toggle<cr>", desc = "Grapple: Tag a file" },
	{ "<leader>mm", "<cmd>Grapple toggle_tags<cr>", desc = "Grapple: Toggle tags menu" },

	{ "<leader>1", "<cmd>Grapple select index=1<cr>", desc = "Grapple: Select 1 tag" },
	{ "<leader>2", "<cmd>Grapple select index=2<cr>", desc = "Grapple: Select 2 tag" },
	{ "<leader>3", "<cmd>Grapple select index=3<cr>", desc = "Grapple: Select 3 tag" },
	{ "<leader>4", "<cmd>Grapple select index=4<cr>", desc = "Grapple: Select 4 tag" },
	{ "<leader>5", "<cmd>Grapple select index=5<cr>", desc = "Grapple: Select 5 tag" },
	{ "<leader>6", "<cmd>Grapple select index=6<cr>", desc = "Grapple: Select 6 tag" },
	{ "<leader>7", "<cmd>Grapple select index=7<cr>", desc = "Grapple: Select 7 tag" },
	{ "<leader>8", "<cmd>Grapple select index=8<cr>", desc = "Grapple: Select 8 tag" },
	{ "<leader>9", "<cmd>Grapple select index=9<cr>", desc = "Grapple: Select 9 tag" },
  },
}
