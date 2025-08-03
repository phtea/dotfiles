return {
  "vague2k/vague.nvim",
  config = function()

	-- Add all persistent highlighs here
	local function persistent_hl()
	  -- Vim illuminate
	  vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = "#3a3a3a", underline = false })
	  vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = "#3a3a3a", underline = false })
	  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#3a3a3a", underline = false })
	  vim.api.nvim_set_hl(0, "StatusLine", { bg = NONE })
	end

	require("vague").setup({transparent = true})
	vim.cmd("colorscheme vague")
	persistent_hl()
  end
}
