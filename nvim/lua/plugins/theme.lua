return {
	"tiagovla/tokyodark.nvim",
	config = function()
		vim.cmd [[
			colorscheme tokyodark
			highlight StatusLine guifg=Normal guibg=NONE gui=bold
			highlight StatusLineNC guifg=Normal guibg=NONE
			highlight ModeMsg guifg=NONE guibg=NONE
		]]
	end,
}
