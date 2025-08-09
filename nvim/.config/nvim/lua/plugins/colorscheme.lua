return {
  "vague2k/vague.nvim",
  config = function()
	local function persistent_hl()
	  -- Vim illuminate
	  vim.api.nvim_set_hl(0, "IlluminatedWordText",  { bg = "#1F1F1F", underline = false })
	  vim.api.nvim_set_hl(0, "IlluminatedWordRead",  { bg = "#1F1F1F", underline = false })
	  vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = "#1F1F1F", underline = false })
	  -- Statusline
	  vim.api.nvim_set_hl(0, "StatusLine", { bg = "" })
	end

	require("vague").setup({
	  transparent = true,
	  italic = false,
	})

	vim.cmd("colorscheme vague")
	persistent_hl()
  end
}
