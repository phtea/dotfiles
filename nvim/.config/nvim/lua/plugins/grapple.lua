return {
	"cbochs/grapple.nvim",
	opts = {
		scope = "git_branch",
		icons = false, -- setting to "true" requires "nvim-web-devicons"
		status = false,
	},
	keys = {
		{ "<leader>ma", "<cmd>Grapple toggle<cr>",         desc = "Grapple: Tag a file" },
		{ "<leader>mm", "<cmd>Grapple toggle_tags<cr>",    desc = "Grapple: Toggle tags menu" },

		{ "<leader>1",  "<cmd>Grapple select index=1<cr>", desc = "Grapple: Select 1 tag" },
		{ "<leader>2",  "<cmd>Grapple select index=2<cr>", desc = "Grapple: Select 2 tag" },
		{ "<leader>3",  "<cmd>Grapple select index=3<cr>", desc = "Grapple: Select 3 tag" },
		{ "<leader>4",  "<cmd>Grapple select index=4<cr>", desc = "Grapple: Select 4 tag" },
	},
}
