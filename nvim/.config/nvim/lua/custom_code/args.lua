-- Replacement for Harpoon

local show_args = function()
	vim.cmd [[
		echo
		args
	]]
end

vim.keymap.set("n", "<leader>ma", function()
	vim.cmd [[
		argadd %
		argdedup
	]]
	show_args()
end, { desc = "Core: Add buffer to arglist" })

vim.keymap.set("n", "<leader>mc", function()
	vim.cmd [[
		%argd
	]]
	show_args()
end, { desc = "Core: Clear all current args" })

vim.keymap.set("n", "<leader>mm", show_args, { desc = "Core: Show all current args" })

vim.keymap.set("n", "<leader>md", function()
	vim.cmd [[
		silent! argdelete %
	]]
	show_args()
end, { desc = "Core: Delete current arg" })

-- <leader>1..9 -> jump to slot
for i = 1, 9 do
	vim.keymap.set("n", "<leader>" .. i, function()
		vim.cmd("silent! " .. i .. "argument")
		show_args()
	end, { desc = ("Core: Select arg " .. i) })
end
