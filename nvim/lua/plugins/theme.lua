return {
	{
		'navarasu/onedark.nvim',
		name = 'onedark',
		lazy = false,
		priority = 1000,
		config = function(_, opts)
			require('onedark').setup(opts)
			require('onedark').load()
		end,
		opts = {
			colors = {
				black = '#131019',
				bg0 = '#1E1E28',
				bg1 = '#2d2939',
				bg2 = '#332E41',
				bg3 = '#393348',
				bg_d = '#1B1923',
			},
			highlights = {
				['@comment'] = { fg = '$blue' },
				['@operator'] = { fg = '$cyan' },
				['@lsp.type.comment'] = { fg = '$blue' },
				['@lsp.type.variable'] = { fg = '$yellow' },
				['@lsp.type.property'] = { fg = '$red' },
				['@lsp.type.generic'] = { fg = '$red' },
			},
		},
	},
}
