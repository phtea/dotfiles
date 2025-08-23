return {
  {
	"Mofiqul/vscode.nvim",
	enabled = false,
	config = function()
	  vim.cmd [[colorscheme vscode]]
	  vim.cmd [[set cursorline]]
	end,
  },
  {
	"webhooked/kanso.nvim",
	config = function ()
	  require('kanso').setup({
		italics = false,
	  })
	  vim.cmd [[colorscheme kanso-zen]]
	end
  }
}
