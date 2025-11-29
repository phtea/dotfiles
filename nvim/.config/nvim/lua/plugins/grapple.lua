if true then return {} end -- disable this plugin

vim.pack.add({ "https://github.com/cbochs/grapple.nvim" })
require("grapple").setup({
	scope = "git_branch",
	icons = false, -- setting to "true" requires "nvim-web-devicons"
	status = false,
})

vim.keymap.set("n", "<leader>ma", "<CMD>Grapple toggle<CR>", { desc = "Grapple: Tag a file" })
vim.keymap.set("n", "<leader>mm", "<CMD>Grapple toggle_tags<CR>", { desc = "Grapple: Toggle tags menu" })

vim.keymap.set("n", "<leader>1", "<CMD>Grapple select index=1<CR>", { desc = "Grapple: Select 1 tag" })
vim.keymap.set("n", "<leader>2", "<CMD>Grapple select index=2<CR>", { desc = "Grapple: Select 2 tag" })
vim.keymap.set("n", "<leader>3", "<CMD>Grapple select index=3<CR>", { desc = "Grapple: Select 3 tag" })
vim.keymap.set("n", "<leader>4", "<CMD>Grapple select index=4<CR>", { desc = "Grapple: Select 4 tag" })
