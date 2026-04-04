-- Highlight yank
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function() vim.highlight.on_yank() end,
})

-- Syntax highlighting for dotenv files
vim.api.nvim_create_autocmd("BufRead", {
	pattern = { ".env", ".env.*" },
	callback = function() vim.bo.filetype = "dosini" end,
})

-- Syntax highlighting for yml files
vim.api.nvim_create_autocmd("BufRead", {
	pattern = { "*.yml", "*.yml.*" },
	callback = function() vim.bo.filetype = "yaml" end,
})

-- Hook for when package is changed (installed, updated, deleted)
-- lazy-style build equivalent
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local data = ev.data or vim.v.event -- depending on Neovim version

		if not data then return end

		local kind = data.kind -- "install" | "update" | "delete"
		local spec = data.spec or {}
		local name = spec.name or ""

		-- Only for nvim-treesitter, and only on install or update
		if name == "nvim-treesitter" and (kind == "install" or kind == "update") then vim.cmd("TSUpdate") end
	end,
})
