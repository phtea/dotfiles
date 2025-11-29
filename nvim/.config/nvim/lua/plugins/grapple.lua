vim.pack.add({ "https://github.com/cbochs/grapple.nvim" })
require("grapple").setup({
	scope = "git_branch",
	icons = false, -- setting to "true" requires "nvim-web-devicons"
	status = false,
})

vim.keymap.set("n", "<leader>ma", "<cmd>Grapple toggle<cr>", { desc = "Grapple: Tag a file" })
vim.keymap.set("n", "<leader>mm", "<cmd>Grapple toggle_tags<cr>", { desc = "Grapple: Toggle tags menu" })

vim.keymap.set("n", "<leader>1", "<cmd>Grapple select index=1<cr>", { desc = "Grapple: Select 1 tag" })
vim.keymap.set("n", "<leader>2", "<cmd>Grapple select index=2<cr>", { desc = "Grapple: Select 2 tag" })
vim.keymap.set("n", "<leader>3", "<cmd>Grapple select index=3<cr>", { desc = "Grapple: Select 3 tag" })
vim.keymap.set("n", "<leader>4", "<cmd>Grapple select index=4<cr>", { desc = "Grapple: Select 4 tag" })
