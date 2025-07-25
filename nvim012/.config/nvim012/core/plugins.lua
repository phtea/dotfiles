vim.pack.add({
	'https://github.com/nvim-telescope/telescope.nvim',
	'https://github.com/nvim-lua/plenary.nvim',
	{ src = 'https://github.com/ThePrimeagen/harpoon', version = "harpoon2", },
	'https://github.com/kylechui/nvim-surround',
	'https://github.com/lewis6991/gitsigns.nvim',
	'https://github.com/stevearc/oil.nvim',
	'https://github.com/rebelot/kanagawa.nvim',
	'https://github.com/nvim-treesitter/nvim-treesitter',
})

-- auto load plugins settings
local plugin_dir = vim.fn.stdpath("config") .. "/plugins"

for _, file in ipairs(vim.fn.readdir(plugin_dir)) do
	if file:match("%.lua$") then
		local mod_name = file:gsub("%.lua$", "")
		local ok, err = pcall(require, "plugins." .. mod_name)
		if not ok then
			vim.notify("Error loading plugin config: " .. mod_name .. "\n" .. err, vim.log.levels.ERROR)
		end
	end
end
