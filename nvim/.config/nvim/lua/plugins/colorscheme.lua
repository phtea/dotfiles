return {
  "vague2k/vague.nvim",
  config = function()
	local function persistent_hl()
	  -- Vim illuminate
	  vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = "#2a2a2a", underline = false })
	  vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = "#2a2a2a", underline = false })
	  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#2a2a2a", underline = false })
	  vim.api.nvim_set_hl(0, "StatusLine", { bg = NONE })
	end

	require("vague").setup({
	  transparent = true,
	  italic = false,
	})

	vim.cmd("colorscheme vague")
	persistent_hl()
  end
}
